#include "header.p4"
#include "parser.p4"

action _drop() {
    drop();
}

action _nop() {
}

action set_nhop(nhop_ipv4, port) {
    modify_field(ipv4.dstAddr, nhop_ipv4);
    modify_field(standard_metadata.egress_spec, port);
}

table ipv4_lpm {
    reads {
        ipv4.dstAddr : lpm;
    }
    actions {
        set_nhop;
        _drop;
    }
    size: 1024;
}

action set_dmac(dmac) {
    modify_field(ethernet.dstAddr, dmac);
}

table forward {
    reads {
        ipv4.dstAddr: exact;
    }
    actions {
        set_dmac;
        _drop;
    }
    size: 512;
}


action rewrite_mac(smac) {
    modify_field(ethernet.srcAddr, smac);
}

table send_frame {
    reads {
        standard_metadata.egress_port: exact;
    }
    actions {
        rewrite_mac;
        _drop;
    }
    size: 256;
}

// XXX VID is used as index into registers
#define MAX_VID 512

register v_valid_reg { // 1 iff the v_* registers have been set for this VID
  width: 1;
  instance_count: MAX_VID;
}

register v_spd_reg {
  width: 8;
  instance_count: MAX_VID;
}

register v_xway_reg {
  width: 8;
  instance_count: MAX_VID;
}

register v_lane_reg {
  width: 3;
  instance_count: MAX_VID;
}

register v_seg_reg {
  width: 8;
  instance_count: MAX_VID;
}

register v_dir_reg {
  width: 1;
  instance_count: MAX_VID;
}

register v_accnt_bal_reg { // sum of tolls
  width: 32;
  instance_count: MAX_VID;
}

register v_nomove_cnt_reg { // number of consecutive pos_reports from the same position
  width: 3;
  instance_count: MAX_VID;
}


#define LR_NUM_XWAY    2
#define LR_NUM_SEG     16'100
#define LR_NUM_LANE    16'3
#define LR_NUM_DIR     2

#define STOPPED_IDX(xway, seg, dir, lane) \
    (((xway) * (LR_NUM_SEG * LR_NUM_DIR * LR_NUM_LANE)) + \
     ((seg) * LR_NUM_DIR * LR_NUM_LANE) + \
     ((dir) * LR_NUM_LANE) + \
     (lane))

#define DIRSEG_IDX(xway, seg, dir) \
    (((xway) * (LR_NUM_SEG * LR_NUM_DIR)) + \
     ((seg) * LR_NUM_DIR) + \
     (dir))



// XXX this has to be updated manually, because the macro is not expanded
//#define NUM_STOPPED_CELLS (LR_NUM_XWAY * (LR_NUM_SEG * LR_NUM_DIR * LR_NUM_LANE))
#define NUM_STOPPED_CELLS 1200

register stopped_cnt_reg {
  width: 8;
  instance_count: NUM_STOPPED_CELLS;
}


// XXX this has to be updated manually, because the macro is not expanded
//#define NUM_TOLL_LOC LR_NUM_XWAY * LR_NUM_SEG * LR_NUM_DIR
#define NUM_DIRSEG 400

register seg_vol_reg {
  width: 8;
  instance_count: NUM_DIRSEG;
}

register seg_ewma_spd_reg { // EWMA of spd for the whole simulation (no windowing)
  width: 16;
  instance_count: NUM_DIRSEG;
}



header_type accident_meta_t {
    fields {
        cur_stp_cnt: 8;
        prev_stp_cnt: 8;
        accident_seg: 8;
        has_accident_ahead: 1;
    }
}
metadata accident_meta_t accident_meta;

header_type v_state_metadata_t {
    fields {
        new: 1; // new vehicle
        new_seg: 1; // are we in a new seg now? i.e. v_state.prev_seg != pos_report.seg
        prev_spd: 8; // state from previous pos_report
        prev_xway: 8;
        prev_lane: 3;
        prev_seg: 8;
        prev_dir: 1;
        prev_nomove_cnt: 3;
        nomove_cnt: 3;
    }
}
metadata v_state_metadata_t v_state;

header_type seg_metadata_t {
    fields {
        vol: 8;
        prev_vol: 8; // vol in the previous seg
        ewma_spd: 16;
    }
}
metadata seg_metadata_t seg_meta;

header_type stopped_metadata_t {
    fields {
        seg0l1: 8;
        seg0l2: 8;
        seg0l3: 8;
        seg1l1: 8;
        seg1l2: 8;
        seg1l3: 8;
        seg2l1: 8;
        seg2l2: 8;
        seg2l3: 8;
        seg3l1: 8;
        seg3l2: 8;
        seg3l3: 8;
        seg4l1: 8;
        seg4l2: 8;
        seg4l3: 8;
        seg0_ord: 8; // OR of all the lanes in this seg
        seg1_ord: 8;
        seg2_ord: 8;
        seg3_ord: 8;
        seg4_ord: 8;
    }
}
metadata stopped_metadata_t stopped_ahead;

action do_update_pos_state() {
    // Load the state for the vehicle's previous location
    register_read(v_state.new, v_valid_reg, pos_report.vid);
    modify_field(v_state.new, ~v_state.new);
    register_read(v_state.prev_spd, v_spd_reg, pos_report.vid);
    register_read(v_state.prev_xway, v_xway_reg, pos_report.vid);
    register_read(v_state.prev_lane, v_lane_reg, pos_report.vid);
    register_read(v_state.prev_seg, v_seg_reg, pos_report.vid);
    register_read(v_state.prev_dir, v_dir_reg, pos_report.vid);

    // Overwrite the previous location state with the current
    register_write(v_valid_reg, pos_report.vid, 1);
    register_write(v_spd_reg, pos_report.vid, pos_report.spd);
    register_write(v_xway_reg, pos_report.vid, pos_report.xway);
    register_write(v_lane_reg, pos_report.vid, pos_report.lane);
    register_write(v_seg_reg, pos_report.vid, pos_report.seg);
    register_write(v_dir_reg, pos_report.vid, pos_report.dir);
}
table update_pos_state {
    actions { do_update_pos_state; }
}

action set_new_seg() {
    modify_field(v_state.new_seg, 1);
}
table update_new_seg {
    actions { set_new_seg; }
}

action do_loc_not_changed() {
    register_read(v_state.prev_nomove_cnt, v_nomove_cnt_reg, pos_report.vid);
    // XXX BMV2 doesn't support saturating, so we do a trick with bit ops:
    // inc the counter, then subtract from it (carry >> 2)
    modify_field(v_state.nomove_cnt,
        (v_state.prev_nomove_cnt + 1) -
            (((v_state.prev_nomove_cnt + 1) & 4) >> 2));
    register_write(v_nomove_cnt_reg, pos_report.vid, v_state.nomove_cnt);
}
table loc_not_changed {
    actions { do_loc_not_changed; }
}

action do_loc_changed() {
    register_read(v_state.prev_nomove_cnt, v_nomove_cnt_reg, pos_report.vid);
    register_write(v_nomove_cnt_reg, pos_report.vid, 0);
}
table loc_changed {
    actions { do_loc_changed; }
}

action load_vol() {
    register_read(seg_meta.vol, seg_vol_reg,
            DIRSEG_IDX(pos_report.xway, pos_report.seg, pos_report.dir));
}

// only called for new vehicles, as there's no previous vol to dec
action load_and_inc_vol() {
    load_vol();
    add_to_field(seg_meta.vol, 1);
    register_write(seg_vol_reg,
            DIRSEG_IDX(pos_report.xway, pos_report.seg, pos_report.dir),
            seg_meta.vol);
}

// called for existing vehicles, because there's a previous vol to dec
action load_and_inc_and_dec_vol() {
    load_and_inc_vol();
    register_read(seg_meta.prev_vol, seg_vol_reg,
            DIRSEG_IDX(v_state.prev_xway, v_state.prev_seg, v_state.prev_dir));
    subtract_from_field(seg_meta.prev_vol, 1);
    register_write(seg_vol_reg,
            DIRSEG_IDX(v_state.prev_xway, v_state.prev_seg, v_state.prev_dir),
            seg_meta.prev_vol);
}


table update_vol_state {
    reads {
        v_state.new: exact;
        v_state.new_seg: exact;
    }
    actions {
        load_vol;                   // 0 0
        load_and_inc_vol;           // 1 1
        load_and_inc_and_dec_vol;   // 0 1
    }
    size: 4;
}

action set_spd() {
    modify_field(seg_meta.ewma_spd, pos_report.spd);
    register_write(seg_ewma_spd_reg,
                DIRSEG_IDX(pos_report.xway, pos_report.seg, pos_report.dir),
                seg_meta.ewma_spd);
}

action calc_ewma_spd() {
    register_read(seg_meta.ewma_spd, seg_ewma_spd_reg,
                DIRSEG_IDX(pos_report.xway, pos_report.seg, pos_report.dir));
    modify_field(seg_meta.ewma_spd,
                ((seg_meta.ewma_spd * (32'128 - 32)) + (pos_report.spd * 16'32)) >> 7);
    register_write(seg_ewma_spd_reg,
                DIRSEG_IDX(pos_report.xway, pos_report.seg, pos_report.dir),
                seg_meta.ewma_spd);
}

table update_ewma_spd {
    reads { seg_meta.vol: exact; }
    actions {
        set_spd;         // 1 (this is the only car in the seg)
        calc_ewma_spd;   // *
    }
    default_action: calc_ewma_spd;
    size: 2;
}

action do_load_stopped_ahead() {
    // Load the count of stopped vehicles ahead
    register_read(stopped_ahead.seg0l1, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg, pos_report.dir, 1));
    register_read(stopped_ahead.seg0l2, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg, pos_report.dir, 2));
    register_read(stopped_ahead.seg0l3, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg, pos_report.dir, 3));

    register_read(stopped_ahead.seg1l1, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+1, pos_report.dir, 1));
    register_read(stopped_ahead.seg1l2, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+1, pos_report.dir, 2));
    register_read(stopped_ahead.seg1l3, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+1, pos_report.dir, 3));

    register_read(stopped_ahead.seg2l1, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+2, pos_report.dir, 1));
    register_read(stopped_ahead.seg2l2, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+2, pos_report.dir, 2));
    register_read(stopped_ahead.seg2l3, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+2, pos_report.dir, 3));

    register_read(stopped_ahead.seg3l1, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+3, pos_report.dir, 1));
    register_read(stopped_ahead.seg3l2, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+3, pos_report.dir, 2));
    register_read(stopped_ahead.seg3l3, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+3, pos_report.dir, 3));

    register_read(stopped_ahead.seg4l1, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+4, pos_report.dir, 1));
    register_read(stopped_ahead.seg4l2, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+4, pos_report.dir, 2));
    register_read(stopped_ahead.seg4l3, stopped_cnt_reg,
                STOPPED_IDX(pos_report.xway, pos_report.seg+4, pos_report.dir, 3));

    // OR the stopped count in each seg
    modify_field(stopped_ahead.seg0_ord,
                stopped_ahead.seg0l1 | stopped_ahead.seg0l2 | stopped_ahead.seg0l3);
    modify_field(stopped_ahead.seg1_ord,
                stopped_ahead.seg1l1 | stopped_ahead.seg1l2 | stopped_ahead.seg1l3);
    modify_field(stopped_ahead.seg2_ord,
                stopped_ahead.seg2l1 | stopped_ahead.seg2l2 | stopped_ahead.seg2l3);
    modify_field(stopped_ahead.seg3_ord,
                stopped_ahead.seg3l1 | stopped_ahead.seg3l2 | stopped_ahead.seg3l3);
    modify_field(stopped_ahead.seg4_ord,
                stopped_ahead.seg4l1 | stopped_ahead.seg4l2 | stopped_ahead.seg4l3);
}
table load_stopped_ahead {
    actions { do_load_stopped_ahead; }
}

action do_dec_prev_stopped() {
    // Load stopped cnt for the previous loc:
    register_read(accident_meta.prev_stp_cnt, stopped_cnt_reg, STOPPED_IDX(
                v_state.prev_xway,
                v_state.prev_seg,
                v_state.prev_dir,
                v_state.prev_lane));
    // Decrement the count:
    register_write(stopped_cnt_reg, STOPPED_IDX(
                v_state.prev_xway,
                v_state.prev_seg,
                v_state.prev_dir,
                v_state.prev_lane),
            accident_meta.prev_stp_cnt - 1
            );
}
table dec_prev_stopped {
    actions { do_dec_prev_stopped; }
}

action do_inc_stopped() {
    // Load the current stopped count for this loc:
    register_read(accident_meta.cur_stp_cnt, stopped_cnt_reg, STOPPED_IDX(
                pos_report.xway,
                pos_report.seg,
                pos_report.dir,
                pos_report.lane));
    // XXX this could overflow
    // Increment the stopped count:
    register_write(stopped_cnt_reg, STOPPED_IDX(
                pos_report.xway,
                pos_report.seg,
                pos_report.dir,
                pos_report.lane),
            accident_meta.cur_stp_cnt + 1
            );
}
table inc_stopped {
    actions { do_inc_stopped; }
}

action set_accident_meta(ofst) {
    modify_field(accident_meta.accident_seg, pos_report.seg + ofst);
    modify_field(accident_meta.has_accident_ahead, 1);
}

table check_accidents {
    reads {
        stopped_ahead.seg0_ord: range;
        stopped_ahead.seg1_ord: range;
        stopped_ahead.seg2_ord: range;
        stopped_ahead.seg3_ord: range;
        stopped_ahead.seg4_ord: range;
    }
    actions {
        set_accident_meta;
    }
    size: 8;
}


header_type toll_metadata_t {
    fields {
        toll: 16;
        has_toll: 1;
        bal: 32;
    }
}
metadata toll_metadata_t toll_meta;

action issue_toll(base_toll) {
    modify_field(toll_meta.has_toll, 1);
    modify_field(toll_meta.toll,
            base_toll * (seg_meta.vol - 16'50) * (seg_meta.vol - 16'50));

    // Update the account balance
    register_read(toll_meta.bal, v_accnt_bal_reg, pos_report.vid);
    add_to_field(toll_meta.bal, toll_meta.toll);
    register_write(v_accnt_bal_reg, pos_report.vid, toll_meta.bal);

}

// These parameters are configurable at runtime
table check_toll {
    reads {
        v_state.new_seg: exact;                     // if the car entered a new seg
        seg_meta.ewma_spd: range;                   // and its spd < 40
        seg_meta.vol: range;                        // and the |cars| in seg > 50
        accident_meta.has_accident_ahead: exact;    // and no accident ahead
    }
    actions {
        issue_toll;
    }
    size: 1;
}

action do_load_accnt_bal() {
    register_read(toll_meta.bal, v_accnt_bal_reg, accnt_bal_req.vid);
}
table load_accnt_bal {
    actions { do_load_accnt_bal; }
}

control ingress {
    if (valid(ipv4)) {
        if (valid(pos_report)) {
            apply(update_pos_state);

            if (v_state.new == 1 or
                v_state.prev_seg != pos_report.seg) {
                apply(update_new_seg);
            }

            apply(update_vol_state);
            apply(update_ewma_spd);

            if (pos_report.xway == v_state.prev_xway and
                pos_report.seg == v_state.prev_seg and
                pos_report.dir == v_state.prev_dir and
                pos_report.lane == v_state.prev_lane) {
                apply(loc_not_changed);
            }
            else {
                apply(loc_changed);
            }

            if (v_state.prev_nomove_cnt == 3 and   // it was stopped
                v_state.nomove_cnt <3              // but it's moved
                ) {
                apply(dec_prev_stopped);           // then dec stopped vehicles for prev loc
            }

            if (v_state.prev_nomove_cnt <3 and     // it wasn't stopped before
                v_state.nomove_cnt == 3            // but is stopped now
                ) {
                apply(inc_stopped);                // then inc stopped vehicles for this loc
            }

            apply(load_stopped_ahead);

            apply(check_accidents);

            apply(check_toll);

        }
        else if (valid(accnt_bal_req)) {
            apply(load_accnt_bal);
        }

        apply(ipv4_lpm);
        apply(forward);
    }
}

header_type egress_metadata_t {
    fields {
        recirculate: 1;
    }
}
metadata egress_metadata_t accident_egress_meta;
metadata egress_metadata_t toll_egress_meta;
metadata egress_metadata_t accnt_bal_egress_meta;

field_list alert_e2e_fl {
    accident_meta;
    accident_egress_meta;
}

action accident_alert_e2e(mir_ses) {
    modify_field(accident_egress_meta.recirculate, 1);
    clone_egress_pkt_to_egress(mir_ses, alert_e2e_fl);
}

action make_accident_alert() {
    modify_field(lr_msg_type.msg_type, LR_MSG_ACCIDENT_ALERT);

    add_header(accident_alert);
    modify_field(accident_alert.time, pos_report.time);
    modify_field(accident_alert.vid, pos_report.vid);
    modify_field(accident_alert.seg, accident_meta.accident_seg);

    remove_header(pos_report);

    modify_field(ipv4.totalLen, 38);
    modify_field(udp.length_, 18);
    modify_field(udp.checksum, 0);
}

table send_accident_alert {
    reads {
        accident_meta.has_accident_ahead: exact;
        accident_egress_meta.recirculate: exact;
    }
    actions {
        accident_alert_e2e;
        make_accident_alert;
    }
}

field_list toll_e2e_fl {
    toll_meta;
    toll_egress_meta;
    seg_meta;
}

action toll_notification_e2e(mir_ses) {
    modify_field(toll_egress_meta.recirculate, 1);
    clone_egress_pkt_to_egress(mir_ses, toll_e2e_fl);
}

action make_toll_notification() {
    modify_field(lr_msg_type.msg_type, LR_MSG_TOLL_NOTIFICATION);

    add_header(toll_notification);
    modify_field(toll_notification.time, pos_report.time);
    modify_field(toll_notification.vid, pos_report.vid);
    modify_field(toll_notification.spd, seg_meta.ewma_spd);
    modify_field(toll_notification.toll, toll_meta.toll);

    remove_header(pos_report);

    modify_field(ipv4.totalLen, 40);
    modify_field(udp.length_, 20);
    modify_field(udp.checksum, 0);
}

table send_toll_notification {
    reads {
        toll_meta.has_toll: exact;
        toll_egress_meta.recirculate: exact;
    }
    actions {
        toll_notification_e2e;
        make_toll_notification;
    }
}

field_list accnt_bal_e2e_fl {
    toll_meta;
    accnt_bal_egress_meta;
}

action accnt_bal_e2e(mir_ses) {
    modify_field(accnt_bal_egress_meta.recirculate, 1);
    clone_egress_pkt_to_egress(mir_ses, accnt_bal_e2e_fl);
}

action make_accnt_bal() {
    modify_field(lr_msg_type.msg_type, LR_MSG_ACCNT_BAL);

    add_header(accnt_bal);
    modify_field(accnt_bal.time, accnt_bal_req.time);
    modify_field(accnt_bal.vid, accnt_bal_req.vid);
    modify_field(accnt_bal.qid, accnt_bal_req.qid);
    modify_field(accnt_bal.bal, toll_meta.bal);

    remove_header(accnt_bal_req);

    modify_field(ipv4.totalLen, 45);
    modify_field(udp.length_, 25);
    modify_field(udp.checksum, 0);
}

table send_accnt_bal {
    reads {
        accnt_bal_egress_meta.recirculate: exact;
    }
    actions {
        accnt_bal_e2e;
        make_accnt_bal;
    }
}


action make_expenditure_report(bal) {
    modify_field(lr_msg_type.msg_type, LR_MSG_EXPENDITURE_REPORT);

    add_header(expenditure_report);
    modify_field(expenditure_report.time, expenditure_req.time);
    modify_field(expenditure_report.emit, expenditure_req.time);
    modify_field(expenditure_report.qid, expenditure_req.qid);
    modify_field(expenditure_report.bal, bal);

    remove_header(expenditure_req);

    modify_field(ipv4.totalLen, 39);
    modify_field(udp.length_, 19);
    modify_field(udp.checksum, 0);
}

table daily_expenditure {
    reads {
        expenditure_req.vid: exact;
        expenditure_req.day: exact;
        expenditure_req.xway: exact;
    }
    actions { make_expenditure_report; }
    size: 1024;
}

header_type travel_estimate_metadata_t {
    fields {
        recirculated: 1;
        dir: 1;
        seg_cur: 8;
        seg_end: 8;
        toll_sum: 16;
        time_sum: 16;
    }
}
metadata travel_estimate_metadata_t te_md;

action do_travel_estimate_init() {
    modify_field(te_md.dir, 0);
    modify_field(te_md.seg_cur, travel_estimate_req.seg_init);
    modify_field(te_md.seg_end, travel_estimate_req.seg_end);
}
table travel_estimate_init {
    actions { do_travel_estimate_init; }
    default_action: do_travel_estimate_init;
    size: 1;
}

action do_travel_estimate_init_rev() {
    modify_field(te_md.dir, 1);
    modify_field(te_md.seg_cur, travel_estimate_req.seg_end);
    modify_field(te_md.seg_end, travel_estimate_req.seg_init);
}
table travel_estimate_init_rev {
    actions { do_travel_estimate_init_rev; }
    default_action: do_travel_estimate_init_rev;
    size: 1;
}

action update_travel_estimate(time, toll) {
    add_to_field(te_md.time_sum, time);
    add_to_field(te_md.toll_sum, toll);
}
table travel_estimate_history {
    reads {
        travel_estimate_req.dow: exact;
        travel_estimate_req.tod: exact;
        travel_estimate_req.xway: exact;
        te_md.dir: exact;
        te_md.seg_cur: exact;
    }
    actions {
        update_travel_estimate;
    }
    size: 1024;
}

field_list te_e2e_fl {
    te_md;
}

action travel_estimate_e2e(mir_ses) {
    add_to_field(te_md.seg_cur, 1);
    modify_field(te_md.recirculated, 1);
    clone_egress_pkt_to_egress(mir_ses, te_e2e_fl);
    drop();
}
table travel_estimate_recirc {
    actions { travel_estimate_e2e; }
    size: 1;
}

action do_travel_estimate_send() {
    modify_field(lr_msg_type.msg_type, LR_MSG_TRAVEL_ESTIMATE);

    add_header(travel_estimate);
    modify_field(travel_estimate.qid, travel_estimate_req.qid);
    modify_field(travel_estimate.travel_time, te_md.time_sum);
    modify_field(travel_estimate.toll, te_md.toll_sum);

    remove_header(travel_estimate_req);

    modify_field(ipv4.totalLen, 37);
    modify_field(udp.length_, 17);
    modify_field(udp.checksum, 0);
}
table travel_estimate_send {
    actions { do_travel_estimate_send; }
    default_action: do_travel_estimate_send;
    size: 1;
}

control egress {
    if (valid(ipv4)) {
        if (valid(pos_report)) {
            apply(send_accident_alert);
            apply(send_toll_notification);
        }
        else if (valid(accnt_bal_req)) {
            apply(send_accnt_bal);
        }
        else if (valid(expenditure_req)) {
            apply(daily_expenditure);
        }
        else if (valid(travel_estimate_req)) {
            if (te_md.recirculated == 0) {
                if (travel_estimate_req.seg_init < travel_estimate_req.seg_end)
                    apply(travel_estimate_init);
                else
                    apply(travel_estimate_init_rev);
            }

            apply(travel_estimate_history);

            if (te_md.seg_cur == te_md.seg_end)
                apply(travel_estimate_send);
            else
                apply(travel_estimate_recirc);
        }
        apply(send_frame);
    }
}
