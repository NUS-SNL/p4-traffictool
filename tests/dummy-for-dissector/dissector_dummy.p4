#include "includes/headers.p4"
#include "includes/parser.p4"

/****** START: Common actions ******/

action nop() {
}


/****** END: Common actions ******/


/****** START: Fake routing related tables and actions ******/

action srcReWrite(newSrcIP){
    modify_field(ipv4.srcAddr, newSrcIP);
}

table src_rewrite {
    reads {
        ipv4.srcAddr : exact;
        ipv4.dstAddr : exact;
    }
    actions {
        srcReWrite; nop;
    }
}



action dstReWrite(newDstIP){
    modify_field(ipv4.dstAddr, newDstIP);
}

table dst_rewrite {
    reads {
        ipv4.dstAddr : exact;
    }
    actions {
        dstReWrite; nop;
    }
}



action forward(newSrcMAC, newDstMAC, egress_spec) {
    // 1. Set the egress port of the next hop
    // modify_field(ig_intr_md_for_tm.ucast_egress_port, egress_spec);
    // 2. Update the ethernet destination address with the address of the next hop.
    modify_field(ethernet.dstAddr, newDstMAC);
    // 3. Update the ethernet source address with the address of the switch.
    modify_field(ethernet.srcAddr, newSrcMAC);
    // 4. Decrement the TTL
    add_to_field(ipv4.ttl, -1);
}

table ipv4_forward {
    reads {
        ipv4.dstAddr : exact;
    }
    actions {
        forward; nop;
    }
}


/****** END: Fake routing related tables and actions ******/




/************ INGRESS PROCESSING PIPELINE ************/

control ingress {
    apply(src_rewrite);
    apply(dst_rewrite);
    apply(ipv4_forward);
}



/************ EGRESS PROCESSING PIPELINE ************/

control egress {


}
