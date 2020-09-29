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
 * Parser for every incoming packet.  We handle the following formats:
 *  - Ethernet
 *  - Ethernet | IPv4
 *  - Ethernet | IPv4 | IPv4 Option | Snapshot
 * We create the following, but should never see it in the parser:
 *  - Ethernet | Snapshot Notification
 **/

#define ETHERTYPE_IPV4 0x0800
#define IPV4_HEADER_LEN 5
#define IPV4_OPTION_SS 31
#define IPV4_OPTION_SS_CPU 30

parser start {
    return parse_ethernet;
}

parser parse_ethernet {
    extract(ethernet);
    return select(latest.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        0x0000 mask 0xFFFF : ingress;
        default: parse_tocpu;
        // default never fires because the
        // mask case matches all. Default is just
        // here to tell the deparser where the
        // tocpu header goes.
    }
}

parser parse_ipv4 {
    extract(ipv4);
    return select(latest.ihl) {
        IPV4_HEADER_LEN : ingress;
        default: parse_ipv4_option;
    }
}

parser parse_ipv4_option {
    extract(ipv4_option);
    return select(latest.option) {
        IPV4_OPTION_SS : parse_snapshot;
        IPV4_OPTION_SS_CPU : parse_snapshot;
        default: ingress;
    }
}

parser parse_snapshot {
    extract(snapshot_header);
    return ingress;
}

// Again, should never be called.  Just here to specify header order.
parser parse_tocpu {
    extract(tocpu_notif);
    return ingress;
}