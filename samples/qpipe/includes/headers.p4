header_type ethernet_t {
    fields {
        dstAddr:    48;
        srcAddr:    48;
        etherType:  16;
    }
}
header ethernet_t ethernet;

header_type ipv4_t {
    fields {
        version:        4;
        ihl:            4;
        diffserv:       8;
        totalLen:       16;
        identification: 16;
        flags:          3;
        fragOffset:     13;
        ttl:            8;
        protocol:       8;
        hdrChecksum:    16;
        srcAddr:        32;
        dstAddr:        32;
    }
}
header ipv4_t ipv4;

header_type tcp_t {
    fields {
        srcPort:    16;
        dstPort:    16;
        seqNo:      32;
        ackNo:      32;
        dataOffset: 4;
        res:        3;
        ecn:        3;
        ctrl:       6;
        window:     16;
        checksum:   16;
        urgentPtr:  16;
    }
}
header tcp_t tcp;

header_type udp_t {
    fields {
        srcPort:    16;
        dstPort:    16;
        pkt_length: 16;
        checksum:   16;
    }
}
header udp_t udp;

header_type pq_hdr_t {
    fields {
        op:         8;
        priority:   8;
        value:      32;
        recirc_flag:16;
    }
}
header pq_hdr_t pq_hdr;

header_type recirculate_hdr_t {
    fields {
        busy: 32;
        option_type: 32;
        array_to_operate: 32;
        theta: 32;
        beta_ing: 32;
        gamma_ing: 32;
        index_beta_ing: 32;
        index_gamma_ing: 32;
        to_delete_num: 32;
        head_v: 32;
    }
}
header recirculate_hdr_t recirculate_hdr;