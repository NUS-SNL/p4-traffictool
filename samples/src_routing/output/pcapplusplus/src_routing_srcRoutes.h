//Template for addition of new protocol 'srcRoutes'

#ifndef P4_SRCROUTES_LAYER
#define P4_SRCROUTES_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
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

		 // Getters for fields
		 uint8_t getBos();
		 uint16_t getPort();

		 inline srcrouteshdr* getSrcroutesHeader() { return (srcrouteshdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(srcrouteshdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif