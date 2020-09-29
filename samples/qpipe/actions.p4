action get_pkt_info_action() {
    modify_field(meta.value, pq_hdr.value);
}

action sample_action() {
    modify_field_rng_uniform(meta.sample, LOWER_BOUND, UPPER_BOUND);
}

action sample_01_action() {
    modify_field_rng_uniform(meta.sample_01, 0, 1);
}

action get_array_to_operate_action() {
    register_read(meta.array_to_operate, array_to_operate_register, 0);
}

action get_quantile_state_action() {
    register_read(meta.busy, quantile_state_register, 0);
}

action get_option_type_action() {
    register_read(meta.option_type, option_type_register, 0);
}

action get_theta_action() {
    register_read(meta.theta, theta_register, meta.array_to_operate);
}

action get_beta_action() {
    register_read(meta.beta, beta_ing_register, 0);
}

action get_gamma_action() {
    register_read(meta.gamma, gamma_ing_register, 0);
}



action get_left_bound_action() {
    register_read(meta.left_bound, left_bound_register, meta.array_to_operate);
}

action get_right_bound_action() {
    register_read(meta.right_bound, right_bound_register, meta.array_to_operate);
}

action get_length_action() {
    register_read(meta.len, length_register, meta.array_to_operate);
}

action inc_tail_action() {

}

action inc_item_num_action() {
}

action put_into_array_action() {
    register_write(a_register, meta.tail, meta.value);
}

action mark_to_resubmit_1_action() {
    modify_field(pq_hdr.recirc_flag, 1);
    add_header(recirculate_hdr);
    // ** recirculate_hdr.busy = 1;
    modify_field(recirculate_hdr.busy, 1);
    // ** recirculate_hdr.array_to_operate = meta.array_to_operate;
    modify_field(recirculate_hdr.array_to_operate, meta.array_to_operate);
    // ** recirculate_hdr.option_type = filter
    modify_field(recirculate_hdr.option_type, FILTER_OPTION);

    modify_field(recirculate_hdr.theta, meta.theta);
    modify_field(recirculate_hdr.beta_ing, meta.beta);
    modify_field(recirculate_hdr.gamma_ing, meta.gamma);

    modify_field(recirculate_hdr.index_beta_ing, meta.index_beta);
    modify_field(recirculate_hdr.index_gamma_ing, meta.index_gamma);

    modify_field(recirculate_hdr.to_delete_num, 0);
}

action resubmit_1_action() {
    recirculate(rec_fl);
    // recirculate(68);
    modify_field(meta.recirced, 1);
}

action set_array_to_operate_action() {
    register_write(array_to_operate_register, 0, recirculate_hdr.array_to_operate);
}

action set_quantile_state_action() {
    register_write(quantile_state_register, 0, recirculate_hdr.busy);
}

action set_option_type_action() {
    register_write(option_type_register, 0, recirculate_hdr.option_type);
}

action inc_filter_index_action() {
}

action fetch_item_action() {
}

action filter_beta_action() {
}

action filter_gamma_action() {
}

action pass_gamma_to_next_stage_action() {
    modify_field(meta.filter_item_2, meta.gamma);
}

action set_gamma_meta_action() {
    modify_field(meta.gamma, meta.filter_item);
}

action pass_filtered_to_next_stage_action() {
    modify_field(meta.filter_item_2, meta.filter_item);
}

action mark_to_resubmit_2_action() {
    modify_field(pq_hdr.recirc_flag, 2);
    add_header(recirculate_hdr);
    // ** recirculate_hdr.busy = 1;
    modify_field(recirculate_hdr.busy, 1);
    // ** recirculate_hdr.array_to_operate = meta.array_to_operate;
    modify_field(recirculate_hdr.array_to_operate, meta.array_to_operate);
    // ** recirculate_hdr.option_type = PRE_DELETE_OPTION
    modify_field(recirculate_hdr.option_type, PRE_DELETE_OPTION);

    modify_field(recirculate_hdr.theta, meta.gamma);
    modify_field(recirculate_hdr.beta_ing, meta.beta);
    modify_field(recirculate_hdr.gamma_ing, meta.gamma);

    modify_field(recirculate_hdr.index_beta_ing, meta.index_beta);
    modify_field(recirculate_hdr.index_gamma_ing, meta.index_gamma);

    modify_field(recirculate_hdr.to_delete_num, 0);
}

action set_theta_action() {
    register_write(theta_register, 0, recirculate_hdr.theta);
}

action set_beta_ing_action() {
    register_write(beta_ing_register, 0, recirculate_hdr.beta_ing);
}

action set_gamma_ing_action() {
    register_write(gamma_ing_register, 0, recirculate_hdr.gamma_ing);
}

action inc_delete_index_action() {
}

action fetch_item_2_action() {
}


action get_max_action() {
    max(meta.max_v, meta.filter_item, meta.old_beta);
}

action get_min_action() {
    max(meta.beta, meta.filter_item, meta.old_beta);
}

action mark_index_beta_action() {
    register_write(index_beta_exg_register, 0, meta.delete_index);
    modify_field(meta.index_beta, meta.delete_index);
}

action get_index_beta_action() {
    register_read(meta.index_beta, index_beta_exg_register, 0);
}

action mark_index_gamma_action() {
    register_write(index_gamma_exg_register, 0, meta.delete_index);
    modify_field(meta.index_gamma, meta.delete_index);
}

action get_index_gamma_action() {
    register_read(meta.index_gamma, index_gamma_exg_register, 0);
}

action mark_to_resubmit_3_action() {
    modify_field(pq_hdr.recirc_flag, 3);
    add_header(recirculate_hdr);
    // ** recirculate_hdr.busy = 1;
    modify_field(recirculate_hdr.busy, 1);
    // ** recirculate_hdr.array_to_operate = meta.array_to_operate;
    modify_field(recirculate_hdr.array_to_operate, meta.array_to_operate);
    // ** recirculate_hdr.option_type = PRE_DELETE_OPTION
    modify_field(recirculate_hdr.option_type, EXE_DELETE_OPTION);

    modify_field(recirculate_hdr.theta, meta.gamma);
    modify_field(recirculate_hdr.beta_ing, meta.beta);
    modify_field(recirculate_hdr.gamma_ing, meta.gamma);

    modify_field(recirculate_hdr.index_beta_ing, meta.index_beta);
    modify_field(recirculate_hdr.index_gamma_ing, meta.index_gamma);

    modify_field(recirculate_hdr.to_delete_num, 2);
}

action set_index_beta_ing_action() {
    register_write(index_beta_ing_register, 0, recirculate_hdr.index_beta_ing);
}

action set_index_gamma_ing_action() {
    register_write(index_gamma_ing_register, 0, recirculate_hdr.index_gamma_ing);
}

action get_index_beta_ing_action() {
    register_read(meta.index_beta, index_beta_ing_register, 0);
}

action get_index_gamma_ing_action() {
    register_read(meta.index_gamma, index_gamma_ing_register, 0);
}

action set_to_delete_num_action() {
    register_write(to_delete_num_register, 0, recirculate_hdr.to_delete_num);
}

action dec_to_delete_num_action() {
}

action inc_head_action() {
}

action get_head_value_action() {
    register_read(meta.head_v, a_register, meta.head);
}

action mark_to_resubmit_4_action() {
    modify_field(pq_hdr.recirc_flag, 4);
    add_header(recirculate_hdr);
    // ** recirculate_hdr.busy = 1;
    modify_field(recirculate_hdr.busy, 1);
    // ** recirculate_hdr.array_to_operate = meta.array_to_operate;
    modify_field(recirculate_hdr.array_to_operate, meta.array_to_operate);
    // ** recirculate_hdr.option_type = PRE_DELETE_OPTION
    modify_field(recirculate_hdr.option_type, EXE_DELETE_OPTION);

    modify_field(recirculate_hdr.theta, meta.gamma);
    modify_field(recirculate_hdr.beta_ing, meta.beta);
    modify_field(recirculate_hdr.gamma_ing, meta.gamma);

    modify_field(recirculate_hdr.index_beta_ing, meta.index_beta);
    modify_field(recirculate_hdr.index_gamma_ing, meta.index_gamma);

    modify_field(recirculate_hdr.to_delete_num, 1);

    modify_field(recirculate_hdr.head_v, meta.head_v);
}

action mark_to_resubmit_5_action() {
    modify_field(pq_hdr.recirc_flag, 5);
    add_header(recirculate_hdr);
    // ** recirculate_hdr.busy = 1;
    modify_field(recirculate_hdr.busy, 1);
    // ** recirculate_hdr.array_to_operate = meta.array_to_operate;
    modify_field(recirculate_hdr.array_to_operate, meta.array_to_operate);
    // ** recirculate_hdr.option_type = PRE_DELETE_OPTION
    modify_field(recirculate_hdr.option_type, EXE_DELETE_OPTION);

    modify_field(recirculate_hdr.theta, meta.gamma);
    modify_field(recirculate_hdr.beta_ing, meta.beta);
    modify_field(recirculate_hdr.gamma_ing, meta.gamma);

    modify_field(recirculate_hdr.index_beta_ing, meta.index_beta);
    modify_field(recirculate_hdr.index_gamma_ing, meta.index_gamma);

    modify_field(recirculate_hdr.to_delete_num, 0);

    modify_field(recirculate_hdr.head_v, meta.head_v);
}

action swap_value_beta_action() {
    register_write(a_register, recirculate_hdr.index_beta_ing, meta.value);
}

action swap_value_gamma_action() {
    register_write(a_register, recirculate_hdr.index_gamma_ing, meta.value);
}

action put_value_to_theta_action() {
    modify_field(meta.value, recirculate_hdr.head_v);
}

action inc_meta_array_to_operate_action() {
    add_to_field(meta.array_to_operate, 1);
}

action pick_beta_action() {
    modify_field(meta.picked_value, meta.beta);
}

action pick_gamma_action() {
    modify_field(meta.picked_value, meta.gamma);
}

action push_value_action() {
    register_write(a_register, meta.tail, meta.value);
}

action mark_to_resubmit_6_action() {
    modify_field(pq_hdr.recirc_flag, 6);
    add_header(recirculate_hdr);
    // ** recirculate_hdr.busy = 1;
    modify_field(recirculate_hdr.busy, 1);
    // ** recirculate_hdr.array_to_operate = meta.array_to_operate;
    modify_field(recirculate_hdr.array_to_operate, meta.array_to_operate);
    // ** recirculate_hdr.option_type = PRE_DELETE_OPTION
    modify_field(recirculate_hdr.option_type, FILTER_OPTION);

    modify_field(recirculate_hdr.theta, meta.gamma);
    modify_field(recirculate_hdr.beta_ing, meta.beta);
    modify_field(recirculate_hdr.gamma_ing, meta.gamma);

    modify_field(recirculate_hdr.index_beta_ing, meta.index_beta);
    modify_field(recirculate_hdr.index_gamma_ing, meta.index_gamma);

    modify_field(recirculate_hdr.to_delete_num, 0);

    modify_field(recirculate_hdr.head_v, meta.head_v);
}

action mark_to_resubmit_7_action() {
    modify_field(pq_hdr.recirc_flag, 7);
    add_header(recirculate_hdr);
    // ** recirculate_hdr.busy = 1;
    modify_field(recirculate_hdr.busy, 0);
    // ** recirculate_hdr.array_to_operate = meta.array_to_operate;
    modify_field(recirculate_hdr.array_to_operate, 0);
    // ** recirculate_hdr.option_type = PRE_DELETE_OPTION
    modify_field(recirculate_hdr.option_type, SAMPLE_OPTION);

    modify_field(recirculate_hdr.theta, 0);
    modify_field(recirculate_hdr.beta_ing, 0);
    modify_field(recirculate_hdr.gamma_ing, 0);

    modify_field(recirculate_hdr.index_beta_ing, 0);
    modify_field(recirculate_hdr.index_gamma_ing, 0);

    modify_field(recirculate_hdr.to_delete_num, 0);

    modify_field(recirculate_hdr.head_v, 0);
}

// inc_tail
action inc_tail_read_action() {
    register_read(meta.tail, tail_register, meta.array_to_operate);
}

action inc_tail_left_bound_action() {
    // meta.tail_n = meta.left_bound
    modify_field(meta.tail_n, meta.left_bound);
}

action inc_tail_plus_action() {
    // meta.tail_n = meta.tail + 1
    add(meta.tail_n, meta.tail, 1);
}

action inc_tail_write_action() {
    register_write(tail_register, meta.array_to_operate, meta.tail_n);
}

// inc_item_num
action inc_item_num_read_action() {
    register_read(meta.item_num, item_num_register, meta.array_to_operate);
}

action inc_item_num_plus_action() {
    // meta.item_num ++
    add_to_field(meta.item_num, 1);
}

action inc_item_num_write_action() {
    register_write(item_num_register, meta.array_to_operate, meta.item_num);
}

// inc_filter_index
action inc_filter_index_read_action() {
    register_read(meta.filter_index, filter_index_register, meta.array_to_operate);
}

action inc_filter_index_left_bound_action() {
    modify_field(meta.filter_index_n, meta.left_bound);
}

action inc_filter_index_plus_action() {
    add(meta.filter_index_n, meta.filter_index, 1);
}

action inc_filter_index_write_action() {
    register_write(filter_index_register, meta.array_to_operate, meta.filter_index_n);
}

// fetch_item
action fetch_item_read_action() {
    register_read(meta.a_value, a_register, meta.array_to_operate);
}

action fetch_item_assign_value_action() {
    // meta.filter_item = meta.a_value
    modify_field(meta.filter_item, meta.a_value);
}

action fetch_item_2_read_action() {
    register_read(meta.a_value, a_register, meta.delete_index);
}

// filter_beta
action filter_beta_read_action() {
    register_read(meta.old_beta, beta_exg_register, 0);
}

action filter_beta_write_action() {
    register_write(beta_exg_register, 0, meta.filter_item);
}

// filter_gamma 
action filter_gamma_read_action() {
    register_read(meta.gamma, gamma_exg_register, 0);
}

action filter_gamma_assign_value_action() {
    modify_field(meta.gamma, meta.max_v);
}

action filter_gamma_write_action() {
    register_write(gamma_exg_register, 0, meta.gamma);
}

// inc_delete_index
action inc_delete_index_read_action() {
    register_read(meta.delete_index, delete_index_register, meta.array_to_operate);
}

action inc_delete_index_left_bound_action() {
    modify_field(meta.delete_index_n, meta.left_bound);
}

action inc_delete_index_plus_action() {
    add(meta.delete_index_n, meta.delete_index, 1);
}

action inc_delete_index_write_action() {
    register_write(delete_index_register, meta.array_to_operate, meta.delete_index_n);
}

// dec_to_delete_num
action dec_to_delete_num_read_action() {
    register_read(meta.to_delete_num, to_delete_num_register, 0);
}

action dec_to_delete_num_minus_action() {
    subtract(meta.to_delete_num_n, meta.to_delete_num, 1);
}

action dec_to_delete_num_unchanged_action() {
    modify_field(meta.to_delete_num_n, meta.to_delete_num);
}

action dec_to_delete_num_write_action() {
    register_write(to_delete_num_register, 0, meta.to_delete_num_n);
}

// inc_head
action inc_head_read_action() {
    register_read(meta.head, head_register, meta.array_to_operate);
}

action inc_head_left_bound_action() {
    modify_field(meta.head_n, meta.left_bound);
}

action inc_head_plus_action() {
    add(meta.head_n, meta.head, 1);
}

action inc_head_write_action() {
    register_write(head_register, meta.array_to_operate, meta.head_n);
}