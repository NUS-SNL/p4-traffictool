/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

const bit<16> TYPE_IPV4C = 0x803;
const bit<8>  TYPE_NONA = 0x23;
const bit<8>  TYPE_PARSA = 0x56;
const bit<8>  TYPE_NONAT = 0x75;
const bit<8>  TYPE_PARSAT = 0x39;

/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

header ipv4c_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ipType;
    bit<8>    ipType2;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

header nona_t {
    bit<2>	fn1;
    bit<2>	fn2;
    bit<4>	fn3;
}

header parsa_t {
    bit<4>	fp1;
    bit<4>	fp2;
}

struct metadata {
    /* empty */
}

struct headers {
    ethernet_t   ethernet;
    ipv4c_t       ipv4c;
    nona_t	 nona;
    parsa_t	 parsa;
}

/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            TYPE_IPV4C: parse_ipv4;
            default: accept;
        }
    }

    state parse_ipv4 {
        packet.extract(hdr.ipv4c);
	transition select(hdr.ipv4c.ipType, hdr.ipv4c.ipType2) {
	    (TYPE_NONA, TYPE_NONAT): parse_nona;
	    (TYPE_PARSA, TYPE_PARSAT): parse_parsa;
	    default: accept;
	}
        //transition accept;
    }

    state parse_nona {
	packet.extract(hdr.nona);
	transition accept;
    }

    state parse_parsa {
	packet.extract(hdr.parsa);
	transition accept;
    }

}

/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {   
    apply {  }
}


/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    action drop() {
        mark_to_drop(standard_metadata);
    }
    
    action ipv4_forward(macAddr_t dstAddr, egressSpec_t port) {
        standard_metadata.egress_spec = port;
        hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = dstAddr;
        hdr.ipv4c.ttl = hdr.ipv4c.ttl - 1;
    }
    
    table ipv4_lpm {
        key = {
            hdr.ipv4c.dstAddr: lpm;
        }
        actions = {
            ipv4_forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }
    
    apply {
        if (hdr.ipv4c.isValid()) {
            ipv4_lpm.apply();
        }
    }
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {  }
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
     apply {
	update_checksum(
	    hdr.ipv4c.isValid(),
            { hdr.ipv4c.version,
	      hdr.ipv4c.ihl,
              hdr.ipv4c.diffserv,
              hdr.ipv4c.totalLen,
              hdr.ipv4c.identification,
              hdr.ipv4c.flags,
              hdr.ipv4c.fragOffset,
              hdr.ipv4c.ttl,
              hdr.ipv4c.protocol,
              hdr.ipv4c.srcAddr,
              hdr.ipv4c.dstAddr },
            hdr.ipv4c.hdrChecksum,
            HashAlgorithm.csum16);
    }
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4c);
    }
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
