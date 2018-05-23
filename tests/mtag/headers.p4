////////////////////////////////////////////////////////////////
// Header type definitions
////////////////////////////////////////////////////////////////

 // Standard L2 Ethernet header
header_type ethernet_t {
    fields {
        bit<48> dst_addr;
        bit<48> src_addr;
        bit<16> ethertype;
    }
}

// Standard VLAN tag
header_type vlan_t {
    fields {
        bit<3> pcp;
        bit cfi;
        bit<12> vid;
        bit<16> ethertype;
    }
}

// The special m-tag used to control forwarding through the
// aggregation layer of data center
header_type mTag_t {
    fields {
        bit<8> up1;
        bit<8> up2;
        bit<8> down1;
        bit<8> down2;
        bit<16> ethertype;
    }
}

// Standard IPv4 header
header_type ipv4_t {
    fields {
        bit<4> version;
        bit<4> ihl;
        bit<8> diffserv;
        bit<16> totalLen;
        bit<16> identification;
        bit<3> flags;
        bit<13> fragOffset;
        bit<8> ttl;
        bit<8> protocol;
        bit<16> hdrChecksum;
        bit<32> srcAddr;
        bit<32> dstAddr;
        varbit<320> options;
    }
    length : ihl * 4;
}

// Assume standard metadata from compiler.

// Define local metadata here.
//
// copy_to_cpu is an example of target specific intrinsic metadata
// It has special significance to the target resulting in a
// copy of the packet being forwarded to the management CPU.

header_type local_metadata_t {
    fields {
        bit<16> cpu_code;    // Code for packet going to CPU
        bit<4> port_type;    // Type of port: up, down, local...
        bit ingress_error;   // An error in ingress port check
        bit was_mtagged;     // Track if pkt was mtagged on ingr
        bit copy_to_cpu;     // Special code resulting in copy to CPU
        bit bad_packet;      // Other error indication
        bit<8> color;        // For metering
    }
}
