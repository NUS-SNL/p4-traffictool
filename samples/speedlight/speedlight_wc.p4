/* Copyright 2018-present University of Pennsylvania
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Top-level ingress/egress control flow for a packet counter snapshot with
 * wraparound of the snapshot ID and snapshotting of channel state.  Does not
 * include forwarding logic, which can occur in parallel.
 **/


#include "./includes/config.p4"
#include "./includes/headers.p4"
#include "./includes/parser.p4"
#include "./includes/ingress_WC.p4"
#include "./includes/egress_WC.p4"
#include "./includes/counter_pkt.p4"
#include "./includes/notify_C.p4"


/*==========================================
=                Ingress                   =
==========================================*/

control ingress {
    if (ethernet.etherType == ETHERTYPE_IPV4) {
        // Handle a (potentially SS) IPv4 packet
        ciHandleIPv4();
    }
}

control ciHandleIPv4 {
    /*
     * Input: snapshot_header.port_id, ingress_port
     * Output: effective_port, snapshot_feature
     * (in ingress.p4)
     */
	ciInitializeSS();
    /*
     * Input: effective_port
     * Output: current_reading
     * (in counter_pkt.p4)
     */
    apply(tiReadAndUpdateCounter);
    /*
     * Input: effective_port, snapshot_feature, snapshot_header.snapshot_id
     * Output: former_last_seen
     * Postcondition: reg_last_seen_in_ingress[index] = snapshot_header.snapshot_id
     * (in ingress_W.p4)
     */
    apply(tiUpdateLastSeen);
    /*
     * Input: former_last_seen, snapshot_header.snapshot_id
     * Output: snapshot_changed_check, snapshot_rollover_check
     * (in ingress_W.p4)
     */
    apply(tiCheckRollover);

    if (snapshot_metadata.snapshot_feature == 0) {
        /*
         * Input: effective_port
         * Output: current_id
         * Postcondition: packet.addIpv4Option(); packet.addSnapshotHeader();
         * (in ingress.p4)
         */
        ciAddHeader();
    } else {
        /*
         * Input: effective_port, former_id, former_last_seen,
         *        snapshot_header.snapshot_id
         * Output: snapshot_case
         * (in ingress_W.p4)
         */
    	if (snapshot_metadata.snapshot_rollover_check == 0) {
	    	ciSetSnapshotCaseNoRollover();
	    } else {
	    	ciSetSnapshotCaseRollover();
	    }
        /*
         * Input: snapshot_case, snapshot_header.snapshot_id, former_id,
         *        current_reading
         * Output: current_id
         * Notification: effective_port, snapshot_header.snapshot_id,
         *               current_reading, ingress_global_tstamp
         * (in ingress_WC.p4)
         */
    	ciTakeSnapshotWithChannelState();
    }
    if (snapshot_metadata.snapshot_feature == 2) {
        /*
         * Input: effective_port
         * Postcondition: packet destined for effective_port's egress
         * (in ingress.p4)
         */
        apply(tiForwardInitiation);
    } else {
        /*
         * Input: current_id, effective_port
         * Postcondition: packet set with above parameters
         * (in ingress.p4)
         */
        apply(tiSetSnapHeader);
    }
}


/*==========================================
=                 Egress                   =
==========================================*/

control egress {
    if (standard_metadata.egress_port == CPU_PORT) {
        // If packet is destined for CPU, remove all headers after eth
        // and stuff the last seen notification into the packet.
        // (in egress.p4)
        apply(teFormatForCpu);
    } else if (ethernet.etherType == ETHERTYPE_IPV4) {
        ceHandleIPv4();
    }
}

control ceHandleIPv4 {
	/*
     * Input: egress_port
     * Output: effective_port
     * (in egress.p4)
     */
    apply(teSetEffectivePort);
    /*
     * Input: effective_port
     * Output: current_reading
     * (in counter_pkt.p4)
     */
    apply(teReadAndUpdateCounter);
    /*
     * Input: effective_port, snapshot_header.port_id, ipv4_option.option,
     *        snapshot_header.snapshot_id
     * Output: former_last_seen
     * (in egress_W.p4)
     */
	apply(teUpdateLastSeen);
    /*
     * Input: former_last_seen, snapshot_header.snapshot_id
     * Output: snapshot_changed_check, snapshot_rollover_check
     * (in egress_W.p4)
     */
    apply(teCheckRollover);
    /*
     * Input: effective_port, former_last_seen, snapshot_header.snapshot_id
     * Output: snapshot_case
     * (in egress_W.p4)
     */
    if (snapshot_metadata.snapshot_rollover_check == 0) {
        ceSetSnapshotCaseNoRollover();
    } else {
        ceSetSnapshotCaseRollover();
    }
    /*
     * Input: snapshot_case, snapshot_header.snapshot_id, former_id,
     *        current_reading
     * Output: current_id
     * Notification: effective_port, snapshot_header.snapshot_id,
     *               current_reading, ingress_global_tstamp
     * (in egress_WC.p4)
     */
    ceTakeSnapshotWithChannelState();
    /*
     * Postcondition: packet either forwarded, dropped, or stripped of its
     * snapshot header.
     * (in egress.p4)
     */
    apply(teFinalizePacket);
}