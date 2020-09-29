#include "includes/defines.p4"
#include "includes/headers.p4"
#include "includes/parser.p4"
#include "routing.p4"
#include "actions.p4"
#include "tables.p4"

// #### metas
header_type meta_t {
    fields {
        recirc_flag: 16;
        sample: 32;
        sample_01: 1;

        recirced: 1;

        head: 32;
        head_n: 32;
        tail: 32;
        tail_n: 32;
        len: 32;
        item_num: 32;
        left_bound: 32;
        right_bound: 32;
        array_to_operate: 32;
        busy: 32;
        option_type: 32;

        theta: 32;
        beta: 32;
        gamma: 32;
        filter_index: 32;
        filter_index_n: 32;
        filter_item: 32;
        delete_index: 32;
        delete_index_n: 32;
        filter_item_2: 32;
        old_beta: 32;
        max_v: 32;
        index_beta: 32;
        index_gamma: 32;
        to_delete_num: 32;
        to_delete_num_n: 32;
        head_v: 32;
        coin: 32;
        picked_value: 32;
        value: 32;
        a_value: 32;
    }
}
metadata meta_t meta;

field_list rec_fl {
    recirculate_hdr;
}

// #### registers
register left_bound_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register right_bound_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register length_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register head_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register tail_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register item_num_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register theta_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register beta_ing_register {
    width: 32;
    instance_count: 1;
}

register beta_exg_register {
    width: 32;
    instance_count: 1;
}

register gamma_ing_register {
    width: 32;
    instance_count: 1;
}

register gamma_exg_register {
    width: 32;
    instance_count: 1;
}

register index_beta_ing_register {
    width: 32;
    instance_count: 1;
}

register index_beta_exg_register {
    width: 32;
    instance_count: 1;
}

register index_gamma_ing_register {
    width: 32;
    instance_count: 1;
}

register index_gamma_exg_register {
    width: 32;
    instance_count: 1;
}

register to_delete_num_register {
    width: 32;
    instance_count: 1;
}



register a_register {
    width: 32;
    instance_count: ARRAY_LEN_INTOTAL;
}

register filter_index_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register delete_index_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register minimum_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register second_minimnum_register {
    width: 32;
    instance_count: ARRAY_NUM;
}

register array_to_operate_register {
    width: 32;
    instance_count: 1;
}

register quantile_state_register {
    width: 32;
    instance_count: 1;
}

register option_type_register {
    width: 32;
    instance_count: 1;
}



control get_basic_info {
    // ** stage 0
    // ** get the current option_type
    apply(get_pkt_info_table);
    apply(get_option_type_table);

    // ** get the target array (to operate)
    apply(get_array_to_operate_table);
    // ** get the state of the quantile (busy?)
    apply(get_quantile_state_table);
    
    // ** stage 1
    // apply(dec_to_delete_num_table);
    dec_to_delete_num();

    // ** get beta
    apply(get_beta_table);

    // ** get gamma
    apply(get_gamma_table);

    // ** stage 2
    // TODO: if (meta.sample != 1)
    if (meta.option_type == EXE_DELETE_OPTION) {
        if (meta.to_delete_num == 0) {
            apply(inc_meta_array_to_operate_table);
        }
    }

    // ** get_beta_index
    apply(get_index_beta_ing_table);

    // ** get_gamma_index
    apply(get_index_gamma_ing_table);

    // ** stage 3
    // ** get queue_infos
    apply(get_left_bound_table);
    apply(get_right_bound_table);
    
    apply(get_length_table);    

    // ** get theta
    apply(get_theta_table);
    
}

control recirculation_1 {
    // ** stage 0
    apply(set_option_type_table);

    apply(set_array_to_operate_table);

    apply(set_quantile_state_table);


    // ** stage 1
    apply(set_to_delete_num_table);

    // ** stage 1
    apply(set_beta_ing_table);
    apply(set_gamma_ing_table);

    // ** stage 2
    apply(set_index_beta_ing_table);
    apply(set_index_gamma_ing_table);

    // ** stage 3
    
    
    apply(set_theta_table);
}

control recirculation_2 {
    // ** stage 0
    apply(set_option_type_table);

    apply(set_array_to_operate_table);

    apply(set_quantile_state_table);


    // ** stage 1
    apply(set_to_delete_num_table);

    // ** stage 1
    apply(set_beta_ing_table);
    apply(set_gamma_ing_table);

    // ** stage 2
    apply(set_index_beta_ing_table);
    apply(set_index_gamma_ing_table);

    // ** stage 3
    
    
    apply(set_theta_table);
}

control recirculation_3 {
    // ** stage 0
    apply(set_option_type_table);

    apply(set_array_to_operate_table);

    apply(set_quantile_state_table);


    // ** stage 1
    apply(set_to_delete_num_table);

    // ** stage 1
    apply(set_beta_ing_table);
    apply(set_gamma_ing_table);

    // ** stage 2
    apply(set_index_beta_ing_table);
    apply(set_index_gamma_ing_table);

    // ** stage 3
    
    
    apply(set_theta_table);
}

control recirculation_4 {
    apply(set_to_delete_num_1_table);
    apply(put_value_to_theta_table);
    apply(swap_value_beta_table);
    
}

control recirculation_5 {
    // apply(put_value_to_theta_table);
    apply(set_to_delete_num_2_table);
    apply(put_value_to_theta_2_table);
    apply(swap_value_gamma_table);
    
}

control recirculation_6 {
    // ** stage 0
    apply(set_option_type_table);

    apply(set_array_to_operate_table);

    apply(set_quantile_state_table);


    // ** stage 1
    apply(set_to_delete_num_table);

    // ** stage 1
    apply(set_beta_ing_table);
    apply(set_gamma_ing_table);

    // ** stage 2
    apply(set_index_beta_ing_table);
    apply(set_index_gamma_ing_table);

    // ** stage 3
    
    
    apply(set_theta_table);
}

control recirculation_7 {
    // ** stage 0
    apply(set_option_type_table);

    apply(set_array_to_operate_table);

    apply(set_quantile_state_table);


    // ** stage 1
    apply(set_to_delete_num_table);

    // ** stage 1
    apply(set_beta_ing_table);
    apply(set_gamma_ing_table);

    // ** stage 2
    apply(set_index_beta_ing_table);
    apply(set_index_gamma_ing_table);

    // ** stage 3
    
    
    apply(set_theta_table);
}

control inc_tail {
    apply(inc_tail_read_table);
    if (meta.tail == meta.right_bound) {
        apply(inc_tail_left_bound_table);
    }
    else {
        apply(inc_tail_plus_table);
    }
    apply(inc_tail_write_table);
}
// ** inc_tail_2

control inc_tail_2 {
    apply(inc_tail_2_read_table);
    if (meta.tail == meta.right_bound) {
        apply(inc_tail_2_left_bound_table);
    }
    else {
        apply(inc_tail_2_plus_table);
    }
    apply(inc_tail_2_write_table);
}

control inc_item_num {
    apply(inc_item_num_read_table);
    if (meta.item_num != meta.len) {
        apply(inc_item_num_plus_table);
    }
    apply(inc_item_num_write_table);
}

control inc_filter_index {
    apply(inc_filter_index_read_table);
    if (meta.filter_index == meta.right_bound) {
        apply(inc_filter_index_left_bound_table);
    }
    else {
        apply(inc_filter_index_plus_table);
    }
    apply(inc_filter_index_write_table);
}

control fetch_item {
    apply(fetch_item_read_table);
    if (meta.a_value > meta.theta) {
        apply(fetch_item_assign_value_table);
    }
}

control fetch_item_2 {
    apply(fetch_item_2_read_table);
    if (meta.a_value > meta.theta) {
        apply(fetch_item_2_assign_value_table);
    }
}

control filter_beta {
    apply(filter_beta_read_table);
    if ((meta.old_beta > meta.filter_item) && (meta.filter_item != 0)) {
        apply(filter_beta_write_table);
    }
}

control filter_gamma {
    apply(filter_gamma_read_table);
    if ((meta.gamma > meta.max_v) && (meta.filter_item != 0)) {
        apply(filter_gamma_assign_value_table);
    }
    apply(filter_gamma_write_table);
}

control inc_delete_index {
    apply(inc_delete_index_read_table);
    if (meta.delete_index == meta.right_bound) {
        apply(inc_delete_index_left_bound_table);
    }
    else {
        apply(inc_delete_index_plus_table);
    }
    apply(inc_delete_index_write_table);
}

control dec_to_delete_num {
    apply(dec_to_delete_num_read_table);
    if ((meta.to_delete_num > 0) && (meta.option_type == EXE_DELETE_OPTION)) {
        apply(dec_to_delete_num_minus_table);
    }
    else {
        apply(dec_to_delete_num_unchanged_table);
    }
    apply(dec_to_delete_num_write_table);
}

control inc_head {
    apply(inc_head_read_table);
    if (meta.head == meta.right_bound) {
        apply(inc_head_left_bound_table);
    }
    else {
        apply(inc_head_plus_table);
    }
    apply(inc_head_write_table);
}

control ingress {
    if (valid(pq_hdr)) {
        if (pq_hdr.recirc_flag == 0) {
            // ** sample pkt
            apply(sample_table);
            apply(sample_01_table);
            
            get_basic_info();
            if (meta.sample == 1) {
                // ** if the array is not full, then push the sampled value into array
                
                if (meta.busy == 0) {
                    // ** stage 4
                    // ** put the value into the array

                    // apply(inc_tail_table);
                    inc_tail();

                    // ** stage 5
                    apply(inc_item_num_table);
                    inc_item_num();

                    // ** stage 6
                    apply(put_into_array_table);

                    if (meta.item_num == meta.len) {
                        // ** stage 10
                        apply(mark_to_resubmit_1_table);
                    }
                }
            }
            else if (meta.sample != 1) {
                if (meta.option_type == FILTER_OPTION) {
                    // ** stage 4
                    // ** filter minimum
                    // apply(inc_filter_index_table);
                    inc_filter_index();

                    // ** stage 6
                    // apply(fetch_item_table);
                    fetch_item();

                    // ** stage 7
                    // apply(filter_beta_table);
                    filter_beta();

                    if (meta.filter_item != 0) {
                        // ** stage 8
                        // meta.max = max(meta.filter_item, meta.old_beta)
                        apply(get_max_table);
                        // meta.beta = min(meta.filter_item, meta.old_beta)
                        apply(get_min_table);
                    }
                    // ** stage 9
                    // apply(filter_gamma_table);
                    filter_gamma();

                    if (meta.filter_index == meta.tail) {
                        // ** stage 10
                        apply(mark_to_resubmit_2_table);
                        // apply(resubmit_1_table);
                    }
                }
                else if (meta.option_type == PRE_DELETE_OPTION) {
                    // ** stage 4
                    // ** find the item to delete 
                    // apply(inc_delete_index_table);
                    inc_delete_index();

                    // ** stage 6
                    // apply(fetch_item_2_table);
                    fetch_item_2();

                    if (meta.beta == meta.filter_item) {
                        // ** stage 7
                        apply(mark_index_beta_table);
                        // ** stage 7
                        apply(get_index_gamma_table);
                    }
                    else {
                        // ** stage 7
                        apply(get_index_beta_table);
                        // ** stage 7
                        if (meta.gamma == meta.filter_item) {
                            apply(mark_index_gamma_table);
                        }
                        else {
                            apply(get_index_gamma_table);
                        }
                    }
                    
                    if (meta.delete_index == meta.tail) {
                        // ** stage 10
                        apply(mark_to_resubmit_3_table);
                    }
                }
                else if (meta.option_type == EXE_DELETE_OPTION) {
                    
                    if (meta.to_delete_num == 0) {
                        // // apply(inc_array_to_operate_table);
                        
                        // ** stage 4
                        // apply(inc_tail_2_table);
                        inc_tail_2();

                        // ** stage 5
                        if (meta.sample_01 == 0) {
                            apply(pick_beta_table);
                        }
                        else {
                            apply(pick_gamma_table);
                        }
                        apply(inc_item_num_2_table);

                        // ** stage 6
                        apply(push_value_table);

                        if (meta.item_num == meta.len) {
                            apply(mark_to_resubmit_6_table);
                        }
                        else {
                            apply(mark_to_resubmit_7_table);
                        }

                    }
                    else {
                        // ** stage 5
                        // apply(inc_head_table);
                        inc_head();

                        // ** stage 6
                        apply(get_head_value_table);
                        if (meta.to_delete_num == 2) {
                            // ** stage 10
                            apply(mark_to_resubmit_4_table);
                        }
                        else if (meta.to_delete_num == 1) {
                            // ** stage 10
                            apply(mark_to_resubmit_5_table);
                        }
                    }
                }
            }
            apply(resubmit_1_table);
        }
        else if (pq_hdr.recirc_flag == 1) {
            recirculation_1();
        }
        else if (pq_hdr.recirc_flag == 2) {
            recirculation_1();
        }
        else if (pq_hdr.recirc_flag == 3) {
            recirculation_1();
        }
        else if (pq_hdr.recirc_flag == 4) {
            recirculation_4();
        }
        else if (pq_hdr.recirc_flag == 5) {
            recirculation_5();
        }
        else if (pq_hdr.recirc_flag == 6) {
            recirculation_1();
        }
        else if (pq_hdr.recirc_flag == 7) {
            recirculation_1();
        }
    }

}

control egress {

}