#include "includes/paxos_headers.p4"
#include "includes/paxos_parser.p4"
#include "l2_control.p4"


register instance_register {
    width : INSTANCE_SIZE;
    instance_count : 1;
}

// This action changes a request message to a 2A message and writes the current instance number to the packet header.
// Then, it increments the current instance number by 1 and stores the result in a register.
action handle_request() {
    modify_field(paxos.msgtype, PAXOS_2A);
    modify_field(paxos.round, 0);	
    register_read(paxos.instance, instance_register, 0);
    add_to_field(paxos.instance, 1);
    register_write(instance_register, 0, paxos.instance);
}

table tbl_sequence {
    reads   { paxos.msgtype : exact; }
    actions { handle_request; _nop; }
    size : 1;
}

control ingress {
    apply(smac);                 /* MAC learning from l2_control.p4... */
    apply(dmac);                 /* ... not doing Paxos logic */
                                 
    if (valid(paxos)) {          /* check if we have a paxos packet */
        apply(tbl_sequence);     /* increase paxos instance number */
     }
}