#include "includes/headers.p4"
#include "includes/parser.p4"

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
