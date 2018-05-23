////////////////////////////////////////////////////////////////
//
// mtag-edge.p4
//
// This file defines the behavior of the edge switch in an mTag
// example.
//
//
////////////////////////////////////////////////////////////////

// Include the header definitions and parser
// (with header instances)
#include "headers.p4"
#include "parser.p4"
#include "actions.p4"   // For actions marked "common_"

#define PORT_COUNT 64 // Total ports in the switch
// These are defined to work around a limitation in p4-1.1-graphs program,
// where it gives an error if there are arithmetic operations in the
// expressions for instance_count and size definitions.
#define PORT_COUNT_SQUARED  4096
#define PORT_COUNT_TIMES_4  256

////////////////////////////////////////////////////////////////
// Table definitions
////////////////////////////////////////////////////////////////

// Remove the mtag for local processing/switching
action _strip_mtag() {
    // Strip the tag from the packet...
    remove_header(mtag);
    // but keep state that it was mtagged.
    modify_field(local_metadata.was_mtagged, 1);
}

// Seems strange to do this, but when running this command:
//
// p4-graphs mtag-edge.p4
//
// on the original mtag-edge.p4 file, I get an error that no_op in a
// table's list of actions is a primitive action, and this was not
// expected.  Putting the primitive actions into explicitly defined
// actions works around this issue.
action _drop() {
    drop();
}
action _no_op() {
    no_op();
}

// Always strip the mtag if present on the edge switch
table strip_mtag {
    reads {
        mtag : valid; // Was mtag parsed?
    }
    actions {
        _strip_mtag;   // Strip mtag and record metadata
        _no_op;         // Pass thru otherwise
    }
}

////////////////////////////////////////////////////////////////

// Identify ingress port: local, up1, up2, down1, down2
table identify_port {
    reads {
        standard_metadata.ingress_port : exact;
    }
    actions { // Each table entry specifies *one* action
        common_set_port_type;
        common_drop_pkt; // If unknown port
        _no_op; // Allow packet to continue
    }
    max_size : 64; // One rule per port
}

// Andy Fingerhut's made-up place holder code for local_switching

action set_egress_spec(in bit<8> espec) {
    modify_field(standard_metadata.egress_spec, espec);
}

table local_switching {
    reads {
        vlan.vid : exact;
        ethernet.dst_addr : exact;
    }
    actions {
        set_egress_spec;
        _no_op;
    }
    max_size : 1024;
}

// Add an mTag to the packet; select egress spec based on up1
action add_mTag(in bit<8> up1, in bit<8> up2,
                in bit<8> down1, in bit<8> down2) {
    add_header(mtag);
    // Copy VLAN ethertype to mTag
    modify_field(mtag.ethertype, vlan.ethertype);

    // Set VLAN’s ethertype to signal mTag
    modify_field(vlan.ethertype, 0xaaaa);

    // Add the tag source routing information
    modify_field(mtag.up1, up1);
    modify_field(mtag.up2, up2);
    modify_field(mtag.down1, down1);
    modify_field(mtag.down2, down2);

    // Set the destination egress port as well from the tag info
    modify_field(standard_metadata.egress_spec, up1);
}

// Count packets and bytes by mtag instance added
counter pkts_by_dest {
    type : packets;
    direct : mTag_table;
}

counter bytes_by_dest {
    type : bytes;
    direct : mTag_table;
}

// Check if the packet needs an mtag and add one if it does.
table mTag_table {
    reads {
        ethernet.dst_addr : exact;
        vlan.vid          : exact;
    }
    actions {
        add_mTag; // Action called if pkt needs an mtag.
        // Option: If no mtag setup, forward to the CPU
        common_copy_pkt_to_cpu;
        _no_op;
    }
    max_size                 : 20000;
}

// Packets from agg layer must stay local; enforce that here
table egress_check {
    reads {
        standard_metadata.ingress_port : exact;
        local_metadata.was_mtagged : exact;
    }

    actions {
        common_drop_pkt;
        _no_op;
    }
    max_size : PORT_COUNT; // At most one rule per port
}

// Egress metering; this could be direct, but we let SW
// use whatever mapping it might like to associate the
// meter cell with the source/dest pair
meter per_dest_by_source {
    type : bytes;
    result : local_metadata.color;
    instance_count : PORT_COUNT_SQUARED; // Per source/dest pair
}

action meter_pkt(in int<12> meter_idx) {
    execute_meter(per_dest_by_source, meter_idx, local_metadata.color);
}

// Mark packet color, for uplink ports only
table egress_meter {
    reads {
        standard_metadata.ingress_port : exact;
        mtag.up1 : exact;
    }
    actions {
        meter_pkt;
        _no_op;
    }
    size : PORT_COUNT_SQUARED; // Could be smaller
}

// Apply meter policy
counter per_color_drops {
    type : packets;
    direct : meter_policy;
}

table meter_policy {
    reads {
        standard_metadata.ingress_port : exact;
        local_metadata.color : exact;
    }
    actions {
        _drop; // Automatically counted by direct counter above
        _no_op;
    }
    size : PORT_COUNT_TIMES_4;
}

////////////////////////////////////////////////////////////////
// Control function definitions
////////////////////////////////////////////////////////////////

// The ingress control function
control ingress {

    // Always strip mtag if present, save state
    apply(strip_mtag);

    // Identify the source port type
    apply(identify_port);

    // If no error from source_check, continue
    if (local_metadata.ingress_error == 0) {
        // Attempt to switch to end hosts
        apply(local_switching); // not shown; matches on dest addr

        // If not locally switched, try to setup mtag
        if (standard_metadata.egress_spec == 0) {
            apply(mTag_table);
        }
    }
}

// The egress control function
control egress {
    // Check for unknown egress state or bad retagging with mTag.
    apply(egress_check);

    // Apply egress_meter table; if hit, apply meter policy
    apply(egress_meter) {
        hit {
            apply(meter_policy);
        }
    }
}
