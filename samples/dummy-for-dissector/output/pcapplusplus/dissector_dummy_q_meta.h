//Template for addition of new protocol 'q_meta'

#ifndef P4_Q_META_LAYER
#define P4_Q_META_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct q_metahdr{
		uint16_t 	 flow_id;
		uint16_t 	 _pad0;
		uint64_t 	 ingress_global_tstamp;
		uint16_t 	 _pad1;
		uint64_t 	 egress_global_tstamp;
		uint16_t 	 _spare_pad_bits;
		uint8_t 	 markbit;
		uint16_t 	 _pad2;
		uint32_t 	 enq_qdepth;
		uint16_t 	 _pad3;
		uint32_t 	 deq_qdepth;
	};

	#pragma pack(pop)
	class Q_metaLayer: public Layer{
		public:
		 Q_metaLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_Q_META;}

		 // Getters for fields
		 uint16_t getFlow_id();
		 uint16_t get_pad0();
		 uint64_t getIngress_global_tstamp();
		 uint16_t get_pad1();
		 uint64_t getEgress_global_tstamp();
		 uint16_t get_spare_pad_bits();
		 uint8_t getMarkbit();
		 uint16_t get_pad2();
		 uint32_t getEnq_qdepth();
		 uint16_t get_pad3();
		 uint32_t getDeq_qdepth();

		 inline q_metahdr* getQ_metaHeader() { return (q_metahdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(q_metahdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif