/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

const bit<16> TYPE_IPV4 = 0x800;
const bit<16> L2_LEARN_ETHER_TYPE = 0x1234;

/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_REPLICATION   = 5;
#define IS_REPLICATED(std_meta) (std_meta.instance_type == BMV2_V1MODEL_INSTANCE_TYPE_REPLICATION)

header ethernet_t {
		macAddr_t dstAddr;
		macAddr_t srcAddr;
		bit<16>   etherType;
}

header ipv4_t {
		bit<4>    version;
		bit<4>    ihl;
		bit<6>    dscp;
		bit<2>    ecn;
		bit<16>   totalLen;
		bit<16>   identification;
		bit<3>    flags;
		bit<13>   fragOffset;
		bit<8>    ttl;
		bit<8>    protocol;
		bit<16>   hdrChecksum;
		ip4Addr_t srcAddr;
		ip4Addr_t dstAddr;
}

header switch_to_cpu_header_t {
		bit<32> word0;
		bit<32> word1;
}


struct headers {
		switch_to_cpu_header_t switch_to_cpu;
		ethernet_t   ethernet;
		ipv4_t       ipv4;
}

struct learn_t{
		bit<48> global_hash;
		bit<48> digest;
		bit<48> approximation;
		bit<32> switch_id;
		bit<16> packet_id;
		bit<8> ttl;
		bit<1> decision;
}

struct metadata {
		bit<9> ingress_port;
		bit<48> approximation;
		bit<48> global_hash;

		bit<48> digest_1;
		bit<48> digest_2;
		bit<48> digest_3;

		bit<32> switch_id;
		bit<32> decider_hash_pint;
		bit<32> decider_hash_asm;
		bit<13> asm_hash_1;
		bit<13> asm_hash_2;
		bit<13> asm_hash_3;
		bit<13> asm_hash_4;
		bit<13> asm_hash_5;
		bit<13> asm_hash_6;
		bit<13> asm_hash_7;
		bit<13> asm_hash_8;

		bit<32> xor_hash;
		learn_t learn_data;
		bit<8> ttl;
		bit<32> b_value;
}


/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser MyParser(packet_in packet,
								out headers hdr,
								inout metadata meta,
								inout standard_metadata_t standard_metadata) {

		state start {
				packet.extract(hdr.ethernet);
				packet.extract(hdr.ipv4);
				transition accept;
		}
}


/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
		apply {  }
}


/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
									inout metadata meta,
									inout standard_metadata_t standard_metadata) {

		action drop() {
				mark_to_drop(standard_metadata);
		}

		action forward(bit<9> egress_port){
				//Standard routing
				standard_metadata.egress_spec=egress_port;

				//Read the current TTL
				bit <32> diff=256-(bit<32>)hdr.ipv4.ttl;

				//Decider hash
				hash(meta.decider_hash_pint, HashAlgorithm.crc32, (bit<1>)0, {hdr.ipv4.identification},(bit<32>)100);

				//XOR hash
				hash(meta.xor_hash, HashAlgorithm.crc32, (bit<1>)0, {hdr.ipv4.identification,diff},(bit<32>)1000000);

				//Hashing to understand if needs to copy digest
				hash(meta.global_hash, HashAlgorithm.crc32, (bit<1>)0, {hdr.ipv4.identification,diff},(bit<48>)1000000);

				/*Creating digest of the switch:
				Using 48 bits of the destination MAC address to accomodate PINT8, PINT4 and PINT1
				Speeds up evaluation.
				*/
				hash(meta.digest_1, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id,hdr.ipv4.identification},(bit<16>)255);
				hash(meta.digest_2, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id,hdr.ipv4.identification},(bit<16>)7);
				hash(meta.digest_3, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id,hdr.ipv4.identification},(bit<16>)1);

				//Combining PINT8, PINT4 and PINT1 into the final digest.
				bit <48> final_digest=(meta.digest_1 << 32) + (meta.digest_2 << 16) + (meta.digest_3);

				//Estimating the XOR of switch ID
				bit<48> xor_extract=1;
				bit<48> dstAddr_1=((xor_extract << 16) - 1) & (hdr.ethernet.dstAddr >> 0);
				bit<48> dstAddr_2=((xor_extract << 16) - 1) & (hdr.ethernet.dstAddr >> 16);
				bit<48> dstAddr_3=((xor_extract << 16) - 1) & (hdr.ethernet.dstAddr >> 32);

				dstAddr_1=dstAddr_1^(bit<48>)meta.switch_id;
				dstAddr_2=dstAddr_2^(bit<48>)meta.switch_id;
				dstAddr_3=dstAddr_3^(bit<48>)meta.switch_id;


				bit<8> dstAddr_1_final=(bit<8>)dstAddr_1;
				bit<4> dstAddr_2_final=(bit<4>)dstAddr_2;
				bit<1> dstAddr_3_final=(bit<1>)dstAddr_3;

				bit <48> final_xor_digest=((bit<48>)dstAddr_1_final << 32) + ((bit<48>)dstAddr_2_final << 16) + ((bit<48>)dstAddr_3_final);

				/*Copying the digest to the destination MAC for
				some packets.
				*/
				if (meta.decider_hash_pint<50){
						if (meta.global_hash<meta.approximation){
								//Copying the digest to Destination MAC
								hdr.ethernet.dstAddr=final_digest;

								//Copying the switch ID to source MAC. Used only for verification
								hdr.ipv4.hdrChecksum=(bit<16>)meta.switch_id;
						}
				}

				/*Copying the XOR digest to the destination MAC for
				some packets.
				*/
				if (meta.decider_hash_pint>=50){
						if (meta.xor_hash<=100000){
								//Copying the digest to Destination MAC
								hdr.ethernet.dstAddr=final_xor_digest;

								//Copying the switch ID to source MAC. Used only for verification
								hdr.ipv4.hdrChecksum=(bit<16>)meta.switch_id;
						}
				}
				//Decider hash ASM
				hash(meta.decider_hash_asm, HashAlgorithm.crc32, (bit<1>)0, {hdr.ipv4.identification},(bit<32>)7);

				hash(meta.asm_hash_1, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+1},(bit<48>)100);
				hash(meta.asm_hash_2, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+2},(bit<48>)100);
				hash(meta.asm_hash_3, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+3},(bit<48>)100);
				hash(meta.asm_hash_4, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+4},(bit<48>)100);
				hash(meta.asm_hash_5, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+5},(bit<48>)100);
				hash(meta.asm_hash_6, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+6},(bit<48>)100);
				hash(meta.asm_hash_7, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+7},(bit<48>)100);
				hash(meta.asm_hash_8, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+8},(bit<48>)100);

				if (meta.global_hash<meta.approximation){
					hdr.ipv4.hdrChecksum=(bit<16>)meta.switch_id;
					if (meta.decider_hash_asm==0){
						bit<16> final_asm_hash=((bit<16>)meta.asm_hash_1<<3)+((bit<16>)meta.decider_hash_asm);
						hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
					}
					if (meta.decider_hash_asm==1){
						bit<16> final_asm_hash=((bit<16>)meta.asm_hash_2<<3)+((bit<16>) meta.decider_hash_asm);
						hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
					}
					if (meta.decider_hash_asm==2){
						bit<16> final_asm_hash=((bit<16>)meta.asm_hash_3<<3)+((bit<16>) meta.decider_hash_asm);
						hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
					}
					if (meta.decider_hash_asm==3){
						bit<16> final_asm_hash=((bit<16>)meta.asm_hash_4<<3)+((bit<16>) meta.decider_hash_asm);
						hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
					}
					if (meta.decider_hash_asm==4){
						bit<16> final_asm_hash=((bit<16>)meta.asm_hash_5<<3)+((bit<16>) meta.decider_hash_asm);
						hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
					}
					if (meta.decider_hash_asm==5){
						bit<16> final_asm_hash=((bit<16>)meta.asm_hash_6<<3)+((bit<16>) meta.decider_hash_asm);
						hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
					}
					if (meta.decider_hash_asm==6){
						bit<16> final_asm_hash=((bit<16>)meta.asm_hash_7<<3)+((bit<16>) meta.decider_hash_asm);
						hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
					}
					if (meta.decider_hash_asm==7){
						bit<16> final_asm_hash=((bit<16>)meta.asm_hash_8<<3)+((bit<16>) meta.decider_hash_asm);
						hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
					}
				}

				hdr.ipv4.ttl=hdr.ipv4.ttl-1;

		}

		table dmac{
				key={
						hdr.ipv4.dstAddr: exact;
				}
				actions={
						forward;
						NoAction;
				}
				size=256;
				default_action=NoAction;
		}


		action copy_to_metadata(bit<48> approximation, bit<32> switch_id, bit<32> b_value){
				meta.approximation=approximation;
				meta.switch_id=switch_id;
				meta.b_value=b_value;
		}

		table ttl_rules{
				key={
						hdr.ipv4.ttl: exact;
				}
				actions={
						copy_to_metadata;
						NoAction;
				}
				size=256;
				default_action=NoAction;
		}

		apply {
				ttl_rules.apply();
				dmac.apply();
		}
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
								 inout metadata meta,
								 inout standard_metadata_t standard_metadata) {
		apply {
				hdr.ipv4.ecn=1;
		}
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers hdr, inout metadata meta) {
		apply {

		}
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
		apply {
				//parsed headers have to be added again into the packet.
				packet.emit(hdr.switch_to_cpu);
				packet.emit(hdr.ethernet);
				packet.emit(hdr.ipv4);
		}
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/
//switch architecture
V1Switch(
		MyParser(),
		MyVerifyChecksum(),
		MyIngress(),
		MyEgress(),
		MyComputeChecksum(),
		MyDeparser()
) main;
