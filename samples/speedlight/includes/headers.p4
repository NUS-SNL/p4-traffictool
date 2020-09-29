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
 * Headers and metadata for Ethernet, IPv4, and Speedlight.  Metadata is not
 * forwarded between switches.
 *
 * Note that notify.p4 and notify_C.p4 contain the notification headers, which
 * which depend on the variant.
 **/


// Intrinsic metadata from the behavioral model
header_type intrinsic_metadata_t {
    fields {
        mcast_grp : 4;
        egress_rid : 4;
    }
}

metadata intrinsic_metadata_t intrinsic_metadata;


// Normal Ethernet and IPv4 header definitions
header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}
header ethernet_t ethernet;

header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr: 32;
    }
}
header ipv4_t ipv4;

header_type ipv4_option_t {
    fields {
        copyFlag : 1;
        optClass : 2;
        option: 5;
        optionLength: 8;
    }
}
header ipv4_option_t ipv4_option;


// IPv4 Checksum computation
field_list ipv4_field_list_snapshot {
    ipv4.version;
    ipv4.ihl;
    ipv4.diffserv;
    ipv4.totalLen;
    ipv4.identification;
    ipv4.flags;
    ipv4.fragOffset;
    ipv4.ttl;
    ipv4.protocol;
    ipv4.srcAddr;
    ipv4.dstAddr;
    ipv4_option.copyFlag;
    ipv4_option.optClass;
    ipv4_option.option;
    ipv4_option.optionLength;
    snapshot_header.snapshot_id;
    snapshot_header.pad_1;
    snapshot_header.port_id;
    snapshot_header.pad_2;
}

field_list_calculation ipv4_chksum_calc_snapshot {
    input {
        ipv4_field_list_snapshot;
    }
    algorithm : csum16;
    output_width: 16;
}

calculated_field ipv4.hdrChecksum {
    update ipv4_chksum_calc_snapshot;
}


// Snapshot headers
header_type snapshot_header_t {
    fields {
        snapshot_id : 16;
        pad_1 : 7;
        port_id : 9;
        pad_2 : 16;
    }
}
header snapshot_header_t snapshot_header;

header_type snapshot_metadata_t {
    fields {
        current_id : 16;
        current_reading: 32;
        pad_1 : 7;
        effective_port : 9; 
        pad_2 : 6;
        snapshot_feature: 2;
        switch_rollover_check : 16 (saturating);
        switch_greater : 16 (saturating);
        packet_greater : 16 (saturating);
        pad_3 : 6;
        snapshot_case : 2;
        pad_4 : 4;
        temp_ihl : 4;
        former_id : 16;
        former_last_seen : 16; 
        snapshot_changed_check : 16;
        snapshot_rollover_check : 16 (saturating);
    }
}
metadata snapshot_metadata_t snapshot_metadata;
