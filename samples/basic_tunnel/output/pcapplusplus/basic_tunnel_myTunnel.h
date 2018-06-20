//Template for addition of new protocol 'myTunnel'

#ifndef P4_MYTUNNEL_LAYER
#define P4_MYTUNNEL_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct mytunnelhdr{
		uint16_t 	 proto_id;
		uint16_t 	 dst_id;
	};

	#pragma pack(pop)
	class MytunnelLayer: public Layer{
		public:
		 MytunnelLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_MYTUNNEL;}

		 // Getters for fields
		 uint16_t getProto_id();
		 uint16_t getDst_id();

		 inline mytunnelhdr* getMytunnelHeader() { return (mytunnelhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(mytunnelhdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif