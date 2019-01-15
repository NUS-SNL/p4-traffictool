//Template for addition of new protocol 'swids'

#ifndef P4_SWIDS_LAYER
#define P4_SWIDS_LAYER

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
	struct swidshdr{
		uint32_t 	 swid;
	};

	#pragma pack(pop)
	class SwidsLayer: public Layer{
		public:
		SwidsLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_SWIDS;}
		SwidsLayer(){
			m_DataLen = sizeof(swidshdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_SWIDS;
		}

		 // Getters and Setters for fields
		 uint32_t getSwid();
		 void setSwid(uint32_t value);

		 inline swidshdr* getSwidsHeader() { return (swidshdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(swidshdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif