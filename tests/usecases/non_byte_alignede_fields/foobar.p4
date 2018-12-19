header_type ethernet_t {    //14 bytes
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}
header ethernet_t ethernet;

header_type ipv4_t {    //20 bytes 
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        fragOffset : 16;
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

header_type foo_t { // 14 bytes
    fields {

        flow_id : 16;
        ingress_tstamp : 32;
        egress_tstamp  : 64;
    }
}
header foo_t foo;

header_type bar_t { // 12 bytes
    fields {
        ingress_tstamp: 16;
        egress_tstamp: 16;
        enq_qdepth: 32;
        deq_qdepth : 32;
    }
}
header bar_t bar;

header_type meta_t {
    fields {
        deq_qdepth: 32;
        bytes_remaining_1 : 32;
        bytes_remaining_2 : 32;
        pkt_size: 32;
        write_ptr: 16;
        read_ptr: 16;
    }
}
metadata meta_t meta;

#define ETHERTYPE_IPV4 0x0800
#define IP_PROTOCOLS_UDP 17
#define FOO_UDP_DST 7777
#define BAR_UDP_DST 8888


parser start {
    return parse_ethernet;
}

parser parse_ethernet {
    extract(ethernet);
    return select(latest.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        default: ingress;
    }
}

parser parse_ipv4 {
    extract(ipv4);
    return select(latest.protocol){
        IP_PROTOCOLS_UDP : parse_udp;
        default : ingress;
    }
}

parser parse_udp{
    extract(udp);
    return select(latest.dstPort){
        FOO_UDP_DST : parse_foo;
        BAR_UDP_DST: parse_bar;
        default : ingress;           
    }
}

parser parse_foo{
    extract(foo);
    return ingress;
}


parser parse_bar{
    extract(bar);
    return ingress;
}

/****** START: Common actions ******/

action nop() {
}


/****** END: Common actions ******/

/****** START: Tables and actions ******/

table do_nothing{
    actions {
        nop;
    }
    default_action: nop;
    size: 1;
}


/****** END: Tables and actions ******/


/************ INGRESS PROCESSING PIPELINE ************/

control ingress {
    apply(do_nothing);
}

/************ EGRESS PROCESSING PIPELINE ************/

control egress {


}
