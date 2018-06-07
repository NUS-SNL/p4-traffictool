#define ETHERTYPE_IPV4 0x0800
#define IP_PROTOCOLS_UDP 17
#define QMETA_UDP_DST 7777
#define SNAPSHOT_DEBUG_UDP_DST 8888


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
        QMETA_UDP_DST : parse_q_meta;
        SNAPSHOT_DEBUG_UDP_DST: parse_snapshot_debug;
        default : ingress;           
    }
}

parser parse_q_meta{
    extract(q_meta);
    return ingress;
}


parser parse_snapshot_debug{
    extract(snapshot);
    return ingress;
}
