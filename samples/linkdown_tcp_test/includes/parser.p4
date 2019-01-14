#define ETHERTYPE_IPV4 0x0800
#define ETHERTYPE_PORTDOWN 0x0666
#define IP_PROTOCOLS_UDP 17
#define IP_PROTOCOLS_TCP 6
#define IP_PROTOCOLS_TEST 253
#define IP_PROTOCOLS_ICMP 1
#define IP_PROTOCOLS_SEQ 254

parser start {
    return select(current(96,16)){
        ETHERTYPE_PORTDOWN: parse_portdown;
        default: parse_ethernet;
    }
}

parser parse_portdown{
    extract(portdown);
    return parse_ipv4;
}



parser parse_ethernet {
    extract(ethernet);
    return select(ethernet.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        default: ingress;
    }
}


parser parse_ipv4 {
    extract(ipv4);
    set_metadata(meta.ipv4_protocol,ipv4.protocol);
    return select(ipv4.protocol) {
        IP_PROTOCOLS_TEST: parse_test;
        IP_PROTOCOLS_SEQ: parse_seq_number;
        IP_PROTOCOLS_TCP: parse_tcp;
        IP_PROTOCOLS_UDP: parse_udp;
        IP_PROTOCOLS_ICMP: parse_icmp;
        default: ingress;
    }    
}


parser parse_test{
    extract(test);
    return select(test.protocol) {
        IP_PROTOCOLS_TCP: parse_tcp;
        IP_PROTOCOLS_UDP: parse_udp;
        IP_PROTOCOLS_ICMP: parse_icmp;
        IP_PROTOCOLS_SEQ: parse_seq_number;
        default: ingress;
    }
}

parser parse_seq_number{
    extract(seq_tsp);
    return ingress;
}


parser parse_udp{
    extract(udp);
    return ingress;
}

parser parse_tcp{
    extract(tcp);
    return ingress;
}


parser parse_icmp{
    extract(icmp);
    return ingress;
}