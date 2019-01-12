#include "includes/defines.p4"
#include "includes/headers.p4"
#include "includes/parsers.p4"
#include "includes/checksum.p4"
#include "routing.p4"



register sequence_reg {
    width: 16;
    instance_count: SEQUENCE_REG_SIZE;
}

register value_reg {
    width: 128;
    instance_count: VALUE_REG_SIZE;
}


header_type location_t {
    fields {
        index: 16;
    }
}
metadata location_t location;

header_type sequence_md_t {
    fields {
        seq: 16;
        tmp: 16;
    }
}
metadata sequence_md_t sequence_md;

header_type my_md_t {
    fields {
        ipaddress: 32;
        role: 16;
        failed: 16;
    }
}
metadata my_md_t my_md;

header_type reply_addr_t {
    fields {
        ipv4_srcAddr: 32;
        ipv4_dstAddr: 32;
    }
}
metadata reply_addr_t reply_to_client_md;

field_list rec_fl {
    standard_metadata;
    location;
    sequence_md;
    my_md;
    reply_to_client_md;
}


action find_index_act(index) {
    modify_field(location.index, index);
}

table find_index {
    reads {
        nc_hdr.key: exact;
    }
    actions {
        find_index_act;
    }
}


action get_sequence_act() {
    register_read(sequence_md.seq, sequence_reg, location.index);
}

table get_sequence {
    actions {
        get_sequence_act;
    }
}

action maintain_sequence_act() {
    add_to_field(sequence_md.seq, 1);
    register_write(sequence_reg, location.index, sequence_md.seq);
    register_read(nc_hdr.seq, sequence_reg, location.index);
}

table maintain_sequence {
    actions {
        maintain_sequence_act;
    }
}

action read_value_act() {
    register_read (nc_hdr.value, value_reg, location.index);
}

table read_value {
    actions {
        read_value_act;
    }
}

action assign_value_act() {
    register_write(sequence_reg, location.index, nc_hdr.seq);
    register_write(value_reg, location.index, nc_hdr.value);
}

table assign_value {
    actions {
        assign_value_act;
    }
}

action pop_chain_act() {
    add_to_field(nc_hdr.sc, -1);
    pop(overlay, 1);
    add_to_field(udp.len, -4);
    add_to_field(ipv4.totalLen, -4);
}

table pop_chain {
    actions {
        pop_chain_act;
    }
}

table pop_chain_again {
    actions {
        pop_chain_act;
    }
}

action gen_reply_act(message_type) {
    modify_field(reply_to_client_md.ipv4_srcAddr, ipv4.dstAddr);
    modify_field(reply_to_client_md.ipv4_dstAddr, ipv4.srcAddr);
    modify_field(ipv4.srcAddr, reply_to_client_md.ipv4_srcAddr);
    modify_field(ipv4.dstAddr, reply_to_client_md.ipv4_dstAddr);
    modify_field(nc_hdr.op, message_type);
    modify_field(udp.dstPort, REPLY_PORT);
}

table gen_reply {
    reads {
        nc_hdr.op: exact;
    }
    actions {
        gen_reply_act;
    }
}

action drop_packet_act() {
    drop();
}

table drop_packet {
    actions {
        drop_packet_act;
    }
}

action get_my_address_act(sw_ip, sw_role) {
    modify_field(my_md.ipaddress, sw_ip);
    modify_field(my_md.role, sw_role);
}

table get_my_address {
    reads {
        nc_hdr.key: exact;
    }
    actions {
        get_my_address_act;
    }
}

action get_next_hop_act() {
    modify_field(ipv4.dstAddr, overlay[0].swip);
}

table get_next_hop {
    actions {
        get_next_hop_act;
    }
}

action failover_act() {
    modify_field(ipv4.dstAddr, overlay[1].swip);
    pop_chain_act();
}

action failover_write_reply_act() {
    gen_reply_act(NC_WRITE_REPLY);
}

action failure_recovery_act(nexthop) {
    modify_field(overlay[0].swip, nexthop);
    modify_field(ipv4.dstAddr, nexthop);
}

action nop() {
    no_op();
}

table failure_recovery {
    reads {
        ipv4.dstAddr: ternary;
        overlay[1].swip: ternary;
        nc_hdr.vgroup: ternary;
    }
    actions {
        failover_act;
        failover_write_reply_act;
        failure_recovery_act;
        nop;
        drop_packet_act;
    }
}

control ingress {
    if (valid(nc_hdr)) {
        apply (get_my_address);
        if (ipv4.dstAddr == my_md.ipaddress) {
            apply (find_index);
            apply (get_sequence);
            if (nc_hdr.op == NC_READ_REQUEST) {
                apply (read_value);
            }
            else if (nc_hdr.op == NC_WRITE_REQUEST) {
                if (my_md.role == HEAD_NODE) {
                    apply (maintain_sequence);
                }
                if ((my_md.role == HEAD_NODE) or (nc_hdr.seq > sequence_md.seq)) {
                    apply (assign_value);
                    apply (pop_chain);
                }
                else {
                    apply (drop_packet);
                }

            }
            if (my_md.role == TAIL_NODE) {
                apply (pop_chain_again);
                apply (gen_reply);
            }
            else {
                apply (get_next_hop);
            }
        }
    }
    if (valid(nc_hdr)) {
        apply (failure_recovery);
        
    }
    if (valid(tcp) or valid(udp)) {
        apply (ipv4_route);
    }
}

control egress {
    apply (ethernet_set_mac);
}

