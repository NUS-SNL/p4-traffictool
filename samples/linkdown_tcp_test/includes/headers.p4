/*********START : headersfor normal pkts********/
header_type ethernet_t {  // 14 bytes
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}
header ethernet_t ethernet;

header_type portdown_t {
    fields{
        pkt_number: 16;
        srcEthAddr: 48;
        etherType: 16;
    }
}
header portdown_t portdown;


header_type ipv4_t {  // 20 bytes
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

header_type tcp_t { // 20 bytes
    fields {
        srcPort     : 16;
        dstPort     : 16;
        seqNo       : 32;
        ackNo       : 32;
        dataOffset  : 4;
        res         : 4;
        flags       : 8;
        window      : 16;
        checksum    : 16;
        urgentPtr   : 16;
    }
}
header tcp_t tcp;

header_type test_t {  // 5 bytes
    fields {
        protocol : 8;
        pkt_tag:32;
        //pkt_number:32;
        egress_ts:48;
        _pad0: 5;
        deq_qdepth:19;
    }
}
header test_t test;

header_type seq_tsp_t { // 10 bytes
    fields {
        seq_number:32;
        egress_ts: 48;
    }
}
header seq_tsp_t seq_tsp;

header_type icmp_t {
    fields {
        typecode    : 16;
        checksum    : 16;
    }
}
header icmp_t icmp;


/*********END : headersfor normal pkts********/

header_type meta_t {
    fields {
        ipv4_protocol:8;
        current_delay_for_mirror_is_enough: 1;
        initial_egr_timestamp : 32;
        initial_egr_port: 9;
        port_state: 1;
        special_port: 9;
        different_time: 32 (signed);
        symmeltry_time: 32;
        directly_subtract:32;
        current_egr_time_is_bigger: 1;
        current_egr_tsp_to32: 32;
        pkt_tag_not_inorder: 1;
        switch_id: 1;
        algo_apply: 1;
        portstate_ingress:1;
    }
}
metadata meta_t meta;



