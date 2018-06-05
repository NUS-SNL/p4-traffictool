header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}
header ethernet_t ethernet;



header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr: 32;
    }
}
header ipv4_t ipv4;



field_list ipv4_field_list {
    ipv4.version;
    ipv4.ihl;
    ipv4.diffserv;
    ipv4.totalLen;
    ipv4.identification;
    ipv4.flags;
    ipv4.fragOffset;
    ipv4.ttl;
    ipv4.protocol;
    ipv4.srcAddr;
    ipv4.dstAddr;
}

field_list_calculation ipv4_chksum_calc {
    input {
        ipv4_field_list;
    }
    algorithm : csum16;
    output_width: 16;
}

calculated_field ipv4.hdrChecksum {
    update ipv4_chksum_calc;
}



header_type udp_t { // 8 bytes
    fields {
        srcPort : 16;
        dstPort : 16;
        hdr_length : 16;
        checksum : 16;
    }
}
header udp_t udp;

header_type queueing_metadata_t { // 28 bytes
    fields {

        flow_id : 16;

        _pad0: 16;
        ingress_global_tstamp : 48;

        _pad1: 16;
        egress_global_tstamp : 48;

        _spare_pad_bits: 15;
        markbit : 1;

        _pad2: 13;
        enq_qdepth: 19;

        _pad3: 13;
        deq_qdepth : 19;
    }
}
header queueing_metadata_t q_meta;


header_type snapshot_debug_t { // 38 bytes
    fields {
        // Original snapshot header fields
        // Basically, what info the courier packet picked up?
        ingress_global_tstamp_hi_16 : 16;
        ingress_global_tstamp_lo_32: 32;
        egress_global_tstamp_lo_32 : 32;
        enq_qdepth: 32;
        deq_qdepth : 32;

        // Debug related fields
        // 1. Which orginal packet generated this courier packet?
        _pad0: 16;
        orig_egress_global_tstamp : 48;
        // 2. When the courier packet arrived in the egress?
        _pad1: 16;
        new_egress_global_tstamp : 48;
        new_enq_tstamp : 32;

    }
}
header snapshot_debug_t snapshot;




header_type meta_t {
    fields {
        deq_qdepth: 32;
        above_threshold: 1;
        bytes_remaining_1 : 32;
        bytes_remaining_2 : 32;
        snapshot: 1;
        pkt_size: 32;

        write_ptr: 16;
        read_ptr: 16;
    }
}
metadata meta_t meta;
