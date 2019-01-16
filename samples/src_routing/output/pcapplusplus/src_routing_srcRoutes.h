//Template for addition of new protocol 'srcRoutes'

#ifndef P4_SRCROUTES_LAYER
#define P4_SRCROUTES_LAYER

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
	struct srcrouteshdr{
		uint8_t 	 bos;
		uint16_t 	 port;
	};

	#pragma pack(pop)
	class SrcroutesLayer: public Layer{
		public:
		SrcroutesLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_SRCROUTES;}
		SrcroutesLayer(){
			m_DataLen = sizeof(srcrouteshdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_SRCROUTES;
		}

		 // Getters and Setters for fields
		 uint8_t getBos();
		 void setBos(uint8_t value);
		 uint16_t getPort();
		 void setPort(uint16_t value);

		 inline srcrouteshdr* getSrcroutesHeader() { return (srcrouteshdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(srcrouteshdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif