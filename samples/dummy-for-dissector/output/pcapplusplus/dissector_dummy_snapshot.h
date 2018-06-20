//Template for addition of new protocol 'snapshot'

#ifndef P4_SNAPSHOT_LAYER
#define P4_SNAPSHOT_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct snapshothdr{
		uint16_t 	 ingress_global_tstamp_hi_16;
		uint32_t 	 ingress_global_tstamp_lo_32;
		uint32_t 	 egress_global_tstamp_lo_32;
		uint32_t 	 enq_qdepth;
		uint32_t 	 deq_qdepth;
		uint16_t 	 _pad0;
		uint64_t 	 orig_egress_global_tstamp;
		uint16_t 	 _pad1;
		uint64_t 	 new_egress_global_tstamp;
		uint32_t 	 new_enq_tstamp;
	};

	#pragma pack(pop)
	class SnapshotLayer: public Layer{
		public:
		 SnapshotLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_SNAPSHOT;}

		 // Getters for fields
		 uint16_t getIngress_global_tstamp_hi_16();
		 uint32_t getIngress_global_tstamp_lo_32();
		 uint32_t getEgress_global_tstamp_lo_32();
		 uint32_t getEnq_qdepth();
		 uint32_t getDeq_qdepth();
		 uint16_t get_pad0();
		 uint64_t getOrig_egress_global_tstamp();
		 uint16_t get_pad1();
		 uint64_t getNew_egress_global_tstamp();
		 uint32_t getNew_enq_tstamp();

		 inline snapshothdr* getSnapshotHeader() { return (snapshothdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(snapshothdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif