/*
    AES-128 encryption in P4
    Copyright (C) 2019 Xiaoqi Chen, Princeton University

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
#define COPYRIGHT_STRING 0xA9204147504c7633
//"© AGPLv3"


// Standard headers
#include <core.p4>
#include <v1model.p4>

#define GEN_LUT0(FN) {}
#define GEN_LUT1(FN) {}
#define GEN_LUT2(FN) {}
#define GEN_LUT3(FN) {}
#define GEN_LUT_SBOX(FN) {}

// We define a special header type to pass in the cleartext & outut ciphertext
header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

#define ETHERTYPE_AES_TOY 0x9999

// We perform one block of AES.
// To perform multiple block using modes like CBC/CTR, etc., simply XOR a counter/IV with value before starting AES.
header aes_inout_t {
    bit<128> value;
    bit<8> ff; // should be 0xFF.
}
header copyright_t {
	bit<64> value;
}

struct my_headers_t {
    ethernet_t   ethernet;
    aes_inout_t     aes_inout;
	copyright_t copy;
}

header aes_meta_t {
    // internal state, 4 rows
    bit<32> r0;
    bit<32> r1;
    bit<32> r2;
    bit<32> r3;
    // temporary accumulator, for XOR-ing the result of many LUTs
    bit<32> t0;
    bit<32> t1;
    bit<32> t2;
    bit<32> t3;
}


struct my_metadata_t {
    aes_meta_t aes;
}

parser MyParser(
    packet_in                 packet,
    out   my_headers_t    hdr,
    inout my_metadata_t   meta,
    inout standard_metadata_t standard_metadata)
{
    state start {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            ETHERTYPE_AES_TOY : parse_aes;
            default      : accept;
        }
    }

    state parse_aes {
        packet.extract(hdr.aes_inout);
        transition accept;
    }
}

control MyVerifyChecksum(inout my_headers_t hdr, inout my_metadata_t meta) {
    apply { }
}

control MyIngress(
    inout my_headers_t     hdr,
    inout my_metadata_t    meta,
    inout standard_metadata_t  standard_metadata)
{
    action reflect() {
        bit<48> tmp;
        // Reflect the packet back to sender.
        standard_metadata.egress_spec = standard_metadata.ingress_port;
        tmp = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
        hdr.ethernet.srcAddr = tmp;
		hdr.copy.setValid();
		hdr.copy.value=COPYRIGHT_STRING;
    }

    action _drop() {
        mark_to_drop(standard_metadata);
    }

	// ===== Start of AES logic =====

	action read_cleartext(){
		meta.aes.t0=hdr.aes_inout.value[127:96];
		meta.aes.t1=hdr.aes_inout.value[95:64];
		meta.aes.t2=hdr.aes_inout.value[63:32];
		meta.aes.t3=hdr.aes_inout.value[31:0];
	}

	action mask_key(bit<128> key128){
		meta.aes.r0= meta.aes.t0^key128[127:96];
		meta.aes.r1= meta.aes.t1^key128[95:64];
		meta.aes.r2= meta.aes.t2^key128[63:32];
		meta.aes.r3= meta.aes.t3^key128[31:0];
	}

	action write_ciphertext(){
		hdr.aes_inout.value[127:96]=meta.aes.r0;
		hdr.aes_inout.value[95:64]=meta.aes.r1;
		hdr.aes_inout.value[63:32]=meta.aes.r2;
		hdr.aes_inout.value[31:0]=meta.aes.r3;

	}

#define TABLE_MASK_KEY(ROUND,SUBKEY128) table mask_key_round_##ROUND { \
		actions = {mask_key;} \
		default_action = mask_key(SUBKEY128); \
	}

#define APPLY_MASK_KEY(ROUND) mask_key_round_##ROUND##.apply();


	action new_round() {
		// Could be skipped, if we use better renaming and read key first.
		// We do this for the sake of code tidyness. More efficient implementation possible, using fewer hardware stages.
		meta.aes.t0=0;  meta.aes.t1=0;  meta.aes.t2=0;  meta.aes.t3=0;
	}

// Macros for defining actions, XOR value from LUT to accummulator variable

#define merge_to(T) action merge_to_t##T##(bit<32> val){\
		meta.aes.t##T##=meta.aes.t##T##^val;	\
	}

// XOR value from LUT to a slice of accummulator variable
#define merge_to_partial(T,SLICE,SLICE_BITS)  action merge_to_t##T##_slice##SLICE##(bit<8> val){ \
	meta.aes.t##T##SLICE_BITS##=meta.aes.t##T##SLICE_BITS##^val;\
	}

// Macros for defining lookup tables, which is match-action table that XOR the value into accumulator variable
#define TABLE_LUT(NAME,READ,WHICH_LUT,WRITE) table NAME { \
		key= {READ:exact;}\
		actions = {WRITE;}\
		const entries = WHICH_LUT(WRITE)\
		}

// We need one copy of all tables for each round. Otherwise, there's dependency issue...
#define GENERATE_ALL_TABLE_LUT(ROUND) LUT00(ROUND) LUT01(ROUND) LUT02(ROUND) LUT03(ROUND) LUT10(ROUND) LUT11(ROUND) LUT12(ROUND) LUT13(ROUND) LUT20(ROUND) LUT21(ROUND) LUT22(ROUND) LUT23(ROUND) LUT30(ROUND) LUT31(ROUND) LUT32(ROUND) LUT33(ROUND)

//Only round 1-9 requires mixcolumns. round 10 is different:
// LAST round is special, use SBOX directly as LUT

#define AP(ROUND,i)  aes_sbox_lut_##i##_r##ROUND##.apply();
#define APPLY_ALL_TABLE_LUT(ROUND) AP(ROUND,00) AP(ROUND,01) AP(ROUND,02) AP(ROUND,03) AP(ROUND,10) AP(ROUND,11) AP(ROUND,12) AP(ROUND,13) AP(ROUND,20) AP(ROUND,21) AP(ROUND,22) AP(ROUND,23) AP(ROUND,30) AP(ROUND,31) AP(ROUND,32) AP(ROUND,33)

	// ==== End of AES LUTs, start of contorl logic ====

    apply {
        if (hdr.aes_inout.isValid() && hdr.aes_inout.ff==0xFF) {
			read_cleartext();

			write_ciphertext();
			// Send the packet back to the sender (for debug only).
			reflect();
        } else {
            _drop();
        }
    }
}

control MyEgress(
    inout my_headers_t        hdr,
    inout my_metadata_t       meta,
    inout standard_metadata_t standard_metadata) {
    apply {   }
}

control MyComputeChecksum(
    inout my_headers_t  hdr,
    inout my_metadata_t meta)
{
    apply {   }
}

control MyDeparser(
    packet_out      packet,
    in my_headers_t hdr)
{
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.aes_inout);
        packet.emit(hdr.copy);
    }
}

V1Switch(
    MyParser(),
    MyVerifyChecksum(),
    MyIngress(),
    MyEgress(),
    MyComputeChecksum(),
    MyDeparser()
) main;
