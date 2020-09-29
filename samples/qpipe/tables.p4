table get_pkt_info_table {
    actions { get_pkt_info_action; }
    default_action: get_pkt_info_action;
}

table sample_table {
    actions { sample_action; }
    default_action: sample_action;
}

table sample_01_table {
    actions { sample_01_action; }
    default_action: sample_01_action;
}

@pragma stage 0
table get_array_to_operate_table {
    actions { get_array_to_operate_action; }
    default_action: get_array_to_operate_action;
}

@pragma stage 0
table get_quantile_state_table {
    actions { get_quantile_state_action; }
    default_action: get_quantile_state_action;
}

@pragma stage 0
table get_option_type_table {
    actions { get_option_type_action; }
    default_action: get_option_type_action;
}


@pragma stage 3
table get_theta_table {
    actions { get_theta_action; }
    default_action: get_theta_action;
}

@pragma stage 1
table get_beta_table {
    actions { get_beta_action; }
    default_action: get_beta_action;
}

@pragma stage 1
table get_gamma_table {
    actions { get_gamma_action; }
    default_action: get_gamma_action;
}

@pragma stage 3
table get_left_bound_table {
    actions { get_left_bound_action; }
    default_action: get_left_bound_action;
}

@pragma stage 3
table get_right_bound_table {
    actions { get_right_bound_action; }
    default_action: get_right_bound_action;
}

@pragma stage 3
table get_length_table {
    actions { get_length_action; }
    default_action: get_length_action;
}

@pragma stage 4
table inc_tail_table {
    actions { inc_tail_action; }
    default_action: inc_tail_action;
}

@pragma stage 4
table inc_tail_2_table {
    actions { inc_tail_action; }
    default_action: inc_tail_action;
}

@pragma stage 5
table inc_item_num_table {
    actions { inc_item_num_action; }
    default_action: inc_item_num_action;
}

@pragma stage 5
table inc_item_num_2_table {
    actions { inc_item_num_action; }
    default_action: inc_item_num_action;
}

@pragma stage 6
table put_into_array_table {
    actions { put_into_array_action; }
    default_action: put_into_array_action;
}

@pragma stage 10
table mark_to_resubmit_1_table {
    actions { mark_to_resubmit_1_action; }
    default_action: mark_to_resubmit_1_action;
}

table resubmit_1_table {
    actions { resubmit_1_action; }
    default_action: resubmit_1_action;
}

@pragma stage 0
table set_array_to_operate_table {
    actions { set_array_to_operate_action; }
    default_action: set_array_to_operate_action; 
}

@pragma stage 0
table set_quantile_state_table {
    actions { set_quantile_state_action; }
    default_action: set_quantile_state_action;
}

@pragma stage 0
table set_option_type_table {
    actions { set_option_type_action; }
    default_action: set_option_type_action;
}

@pragma stage 4
table inc_filter_index_table {
    actions { inc_filter_index_action; }
    default_action: inc_filter_index_action;
}

@pragma stage 6
table fetch_item_table {
    actions { fetch_item_action; }
    default_action: fetch_item_action;
}

@pragma stage 7
table filter_beta_table {
    actions { filter_beta_action; }
    default_action: filter_beta_action;
}

@pragma stage 9
table filter_gamma_table {
    actions { filter_gamma_action; }
    default_action: filter_gamma_action;
}

@pragma stage 10
table mark_to_resubmit_2_table {
    actions { mark_to_resubmit_2_action; }
    default_action: mark_to_resubmit_2_action;
}

@pragma stage 3
table set_theta_table {
    actions { set_theta_action; }
    default_action: set_theta_action;
}

@pragma stage 1
table set_beta_ing_table {
    actions { set_beta_ing_action; }
    default_action: set_beta_ing_action;
}

@pragma stage 1
table set_gamma_ing_table {
    actions { set_gamma_ing_action; }
    default_action: set_gamma_ing_action;
}

@pragma stage 4
table inc_delete_index_table {
    actions { inc_delete_index_action; }
    default_action: inc_delete_index_action;
}

@pragma stage 6
table fetch_item_2_table {
    actions { fetch_item_2_action; }
    default_action: fetch_item_2_action;
}

@pragma stage 7
table mark_index_beta_table {
    actions { mark_index_beta_action; }
    default_action: mark_index_beta_action;
}

@pragma stage 7
table get_index_beta_table {
    actions { get_index_beta_action; }
    default_action: get_index_beta_action;
}

@pragma stage 7
table mark_index_gamma_table {
    actions { mark_index_gamma_action; }
    default_action: mark_index_gamma_action;
}

@pragma stage 7
table get_index_gamma_table {
    actions { get_index_gamma_action; }
    default_action: get_index_gamma_action;
}

@pragma stage 10
table mark_to_resubmit_3_table {
    actions { mark_to_resubmit_3_action; }
    default_action: mark_to_resubmit_3_action;
}

@pragma stage 8
table get_max_table {
    actions { get_max_action; }
    default_action: get_max_action;
}

@pragma stage 8
table get_min_table {
    actions { get_min_action; }
    default_action: get_min_action;
}

@pragma stage 2
table set_index_beta_ing_table {
    actions { set_index_beta_ing_action; }
    default_action: set_index_beta_ing_action;
}

@pragma stage 2
table set_index_gamma_ing_table {
    actions { set_index_gamma_ing_action; }
    default_action: set_index_gamma_ing_action;
}

@pragma stage 2
table get_index_beta_ing_table {
    actions { get_index_beta_ing_action; }
    default_action: get_index_beta_ing_action;
}

@pragma stage 2
table get_index_gamma_ing_table {
    actions { get_index_gamma_ing_action; }
    default_action: get_index_gamma_ing_action;
}

@pragma stage 1
table set_to_delete_num_table {
    actions { set_to_delete_num_action; }
    default_action: set_to_delete_num_action;
}

@pragma stage 1
table set_to_delete_num_1_table {
    actions { set_to_delete_num_action; }
    default_action: set_to_delete_num_action;
}

@pragma stage 1
table set_to_delete_num_2_table {
    actions { set_to_delete_num_action; }
    default_action: set_to_delete_num_action;
}

@pragma stage 1
table dec_to_delete_num_table {
    actions { dec_to_delete_num_action; }
    default_action: dec_to_delete_num_action;
}

@pragma stage 5
table inc_head_table {
    actions { inc_head_action; }
    default_action: inc_head_action;
}

@pragma stage 6
table get_head_value_table {
    actions { get_head_value_action; }
    default_action: get_head_value_action;
}

@pragma stage 6
table swap_value_beta_table {
    actions { swap_value_beta_action; }
    default_action: swap_value_beta_action;
}

@pragma stage 6
table swap_value_gamma_table {
    actions { swap_value_gamma_action; }
    default_action: swap_value_gamma_action; 
}

@pragma stage 10
table mark_to_resubmit_4_table {
    actions { mark_to_resubmit_4_action; }
    default_action: mark_to_resubmit_4_action;
}

@pragma stage 10
table mark_to_resubmit_5_table {
    actions { mark_to_resubmit_5_action; }
    default_action: mark_to_resubmit_5_action;
}

table put_value_to_theta_table {
    actions { put_value_to_theta_action; }
    default_action: put_value_to_theta_action;
}

table put_value_to_theta_2_table {
    actions { put_value_to_theta_action; }
    default_action: put_value_to_theta_action;
}

@pragma stage 2
table inc_meta_array_to_operate_table {
    actions { inc_meta_array_to_operate_action; }
    default_action: inc_meta_array_to_operate_action;
}

@pragma stage 5
table pick_beta_table {
    actions { pick_beta_action; }
    default_action: pick_beta_action;
}

@pragma stage 5
table pick_gamma_table {
    actions { pick_gamma_action; }
    default_action: pick_gamma_action;
}

@pragma stage 6
table push_value_table {
    actions { push_value_action; }
    default_action: push_value_action;
}

@pragma stage 10
table mark_to_resubmit_6_table {
    actions { mark_to_resubmit_6_action; }
    default_action: mark_to_resubmit_6_action;
}

@pragma stage 10
table mark_to_resubmit_7_table {
    actions { mark_to_resubmit_7_action; }
    default_action: mark_to_resubmit_7_action;
}

// inc_tail 
table inc_tail_read_table {
    actions { inc_tail_read_action; }
    default_action: inc_tail_read_action;
}

table inc_tail_left_bound_table {
    actions { inc_tail_left_bound_action; }
    default_action: inc_tail_left_bound_action;
}

table inc_tail_plus_table {
    actions { inc_tail_plus_action; }
    default_action: inc_tail_plus_action;
}

table inc_tail_write_table {
    actions { inc_tail_write_action; }
    default_action: inc_tail_write_action;
}

// inc_tail_2 
table inc_tail_2_read_table {
    actions { inc_tail_read_action; }
    default_action: inc_tail_read_action;
}

table inc_tail_2_left_bound_table {
    actions { inc_tail_left_bound_action; }
    default_action: inc_tail_left_bound_action;
}

table inc_tail_2_plus_table {
    actions { inc_tail_plus_action; }
    default_action: inc_tail_plus_action;
}

table inc_tail_2_write_table {
    actions { inc_tail_write_action; }
    default_action: inc_tail_write_action;
}

// inc_item_num 
table inc_item_num_read_table {
    actions { inc_item_num_read_action; }
    default_action: inc_item_num_read_action;
}

table inc_item_num_plus_table {
    actions { inc_item_num_plus_action; }
    default_action: inc_item_num_plus_action;
}

table inc_item_num_write_table {
    actions { inc_item_num_write_action; }
    default_action: inc_item_num_write_action;
}

// inc_filter_index
table inc_filter_index_read_table {
    actions { inc_filter_index_read_action; }
    default_action: inc_filter_index_read_action;
}

table inc_filter_index_left_bound_table {
    actions { inc_filter_index_left_bound_action; }
    default_action: inc_filter_index_left_bound_action;
}

table inc_filter_index_plus_table {
    actions { inc_filter_index_plus_action; }
    default_action: inc_filter_index_plus_action;
}

table inc_filter_index_write_table {
    actions { inc_filter_index_write_action; }
    default_action: inc_filter_index_write_action;
}

// fetch_item 
table fetch_item_read_table {
    actions { fetch_item_read_action; }
    default_action: fetch_item_read_action;
}

table fetch_item_assign_value_table {
    actions { fetch_item_assign_value_action; }
    default_action: fetch_item_assign_value_action;
}

table fetch_item_2_assign_value_table {
    actions { fetch_item_assign_value_action; }
    default_action: fetch_item_assign_value_action;
}

table fetch_item_2_read_table {
    actions { fetch_item_2_read_action; }
    default_action: fetch_item_2_read_action;
}

// filter_beta
table filter_beta_read_table {
    actions { filter_beta_read_action; }
    default_action: filter_beta_read_action;
}

table filter_beta_write_table {
    actions { filter_beta_write_action; }
    default_action: filter_beta_write_action;
}

// filter_gamma
table filter_gamma_read_table {
    actions { filter_gamma_read_action; }
    default_action: filter_gamma_read_action;
}

table filter_gamma_assign_value_table {
    actions { filter_gamma_assign_value_action; }
    default_action: filter_gamma_assign_value_action;
}

table filter_gamma_write_table {
    actions { filter_gamma_write_action; }
    default_action: filter_gamma_write_action;
}

// inc_delete_index
table inc_delete_index_read_table {
    actions { inc_delete_index_read_action; }
    default_action: inc_delete_index_read_action;
}

table inc_delete_index_left_bound_table {
    actions { inc_delete_index_left_bound_action; }
    default_action: inc_delete_index_left_bound_action;
}

table inc_delete_index_plus_table {
    actions { inc_delete_index_plus_action; }
    default_action: inc_delete_index_plus_action;
}

table inc_delete_index_write_table {
    actions { inc_delete_index_write_action; }
    default_action: inc_delete_index_write_action;
}

// dec_to_delete_num
table dec_to_delete_num_read_table {
    actions { dec_to_delete_num_read_action; }
    default_action: dec_to_delete_num_read_action;
}

table dec_to_delete_num_minus_table {
    actions { dec_to_delete_num_minus_action; }
    default_action: dec_to_delete_num_minus_action;
}

table dec_to_delete_num_unchanged_table {
    actions { dec_to_delete_num_unchanged_action; }
    default_action: dec_to_delete_num_unchanged_action;
}

table dec_to_delete_num_write_table {
    actions { dec_to_delete_num_write_action; }
    default_action: dec_to_delete_num_write_action;
}

// inc_head
table inc_head_read_table {
    actions { inc_head_read_action; }
    default_action: inc_head_read_action;
}

table inc_head_left_bound_table {
    actions { inc_head_left_bound_action; }
    default_action: inc_head_left_bound_action;
}

table inc_head_plus_table {
    actions { inc_head_plus_action; }
    default_action: inc_head_plus_action;
}

table inc_head_write_table {
    actions { inc_head_write_action; }
    default_action: inc_head_write_action;
}