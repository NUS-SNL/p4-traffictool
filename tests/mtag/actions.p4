////////////////////////////////////////////////////////////////
//
// actions.p4
//
// This file defines the common actions that can be exercised by
// either an edge or an aggregation switch.
//
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
// Actions used by tables
////////////////////////////////////////////////////////////////

// Copy the packet to the CPU;
action common_copy_pkt_to_cpu(in bit<8> cpu_code, in bit bad_packet) {
    modify_field(local_metadata.copy_to_cpu, 1);
    modify_field(local_metadata.cpu_code, cpu_code);
    modify_field(local_metadata.bad_packet, bad_packet);
}

// Drop the packet; optionally send to CPU and mark bad
action common_drop_pkt(in bit do_copy, in bit<8> cpu_code, in bit bad_packet) {
    modify_field(local_metadata.copy_to_cpu, do_copy);
    modify_field(local_metadata.cpu_code, cpu_code);
    modify_field(local_metadata.bad_packet, bad_packet);
    drop();
}

// Set the port type; see run time mtag_port_type.
// Allow error indication.
action common_set_port_type(in bit<4> port_type, in bit ingress_error) {
    modify_field(local_metadata.port_type, port_type);
    modify_field(local_metadata.ingress_error, ingress_error);
}
