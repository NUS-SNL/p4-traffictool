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
 * Channel state version of notification.  We generate the notification's
 * metadata but don't add the header immediately because we don't want to modify
 * the original packet.  On final egress, we add the header and format it for
 * the CPU.
 **/

header_type tocpu_t {
    fields {
        message_type : 8;
        current_port : 16;
        neighbor_port : 16;
        former_id : 16;
        current_id : 16;
        former_last_seen : 16;
        current_last_seen : 16;
    }
}
metadata tocpu_t tocpu_metadata;
header tocpu_t tocpu_notif;

field_list flLastSeen {
    tocpu_metadata.message_type; 
    tocpu_metadata.current_port;
    tocpu_metadata.neighbor_port;
    tocpu_metadata.former_id;
    tocpu_metadata.current_id;
    tocpu_metadata.former_last_seen;
    tocpu_metadata.current_last_seen;
}


action aiSendNotification(message_type) {
    modify_field(tocpu_metadata.message_type, message_type);
    modify_field(tocpu_metadata.current_port, snapshot_metadata.effective_port);
    modify_field(tocpu_metadata.neighbor_port, snapshot_header.port_id);
    modify_field(tocpu_metadata.former_id, snapshot_metadata.former_id);
    modify_field(tocpu_metadata.current_id, snapshot_header.snapshot_id);
    modify_field(tocpu_metadata.former_last_seen,
                 snapshot_metadata.former_last_seen);
    modify_field(tocpu_metadata.current_last_seen, snapshot_header.snapshot_id);

    clone_ingress_pkt_to_egress(CPU_INGRESS_MIRROR_ID, flLastSeen);
}

action aeSendNotification(message_type) {
    modify_field(tocpu_metadata.message_type, message_type);
    modify_field(tocpu_metadata.current_port, snapshot_metadata.effective_port);
    modify_field(tocpu_metadata.neighbor_port , snapshot_header.port_id);
    modify_field(tocpu_metadata.former_id, snapshot_metadata.former_id);
    modify_field(tocpu_metadata.current_id, snapshot_header.snapshot_id);
    modify_field(tocpu_metadata.former_last_seen,
                 snapshot_metadata.former_last_seen);
    modify_field(tocpu_metadata.current_last_seen, snapshot_header.snapshot_id);

    clone_egress_pkt_to_egress(CPU_EGRESS_MIRROR_ID, flLastSeen);
}

action aeFormatForCpu() {
    // remove unnecessary headers
    remove_header(snapshot_header);
    remove_header(ipv4_option);
    remove_header(ipv4);

    // add export header
    add_header(tocpu_notif);

    // fill export header
    modify_field(tocpu_notif.message_type, tocpu_metadata.message_type);
    modify_field(tocpu_notif.current_port, tocpu_metadata.current_port);
    modify_field(tocpu_notif.neighbor_port, tocpu_metadata.neighbor_port);
    modify_field(tocpu_notif.former_id, tocpu_metadata.former_id);
    modify_field(tocpu_notif.current_id, tocpu_metadata.current_id);
    modify_field(tocpu_notif.former_last_seen, tocpu_metadata.former_last_seen);
    modify_field(tocpu_notif.current_last_seen,
                 tocpu_metadata.current_last_seen);

    // change ethertype to snapshot ether
    modify_field(ethernet.etherType, ETHERTYPE_TOCPU);
}
