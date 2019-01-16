//Template for addition of new protocol 'q_meta'

#ifndef P4_Q_META_LAYER
#define P4_Q_META_LAYER

#include <cstring>
#include "Layer.h"
#include "uint24_t.h"
#include "uint40_t.h"
#include "uint48_t.h"
#if defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct q_metahdr{
		uint24_t 	 enq_qdepth;
		uint24_t 	 deq_qdepth;
		uint32_t 	 deq_timedelta;
		uint32_t 	 enq_timestamp;
	};

	#pragma pack(pop)
	class Q_metaLayer: public Layer{
		public:
		Q_metaLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_Q_META;}
		Q_metaLayer(){
			m_DataLen = sizeof(q_metahdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_Q_META;
		}

		 // Getters and Setters for fields
		 uint32_t getEnq_qdepth();
		 void setEnq_qdepth(uint32_t value);
		 uint32_t getDeq_qdepth();
		 void setDeq_qdepth(uint32_t value);
		 uint32_t getDeq_timedelta();
		 void setDeq_timedelta(uint32_t value);
		 uint32_t getEnq_timestamp();
		 void setEnq_timestamp(uint32_t value);

		 inline q_metahdr* getQ_metaHeader() { return (q_metahdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(q_metahdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif