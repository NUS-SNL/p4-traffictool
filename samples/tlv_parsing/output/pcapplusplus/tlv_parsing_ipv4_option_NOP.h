//Template for addition of new protocol 'ipv4_option_NOP'

#ifndef P4_IPV4_OPTION_NOP_LAYER
#define P4_IPV4_OPTION_NOP_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct ipv4_option_nophdr{
		uint8_t 	 value;
	};

	#pragma pack(pop)
	class Ipv4_option_nopLayer: public Layer{
		public:
		 Ipv4_option_nopLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_IPV4_OPTION_NOP;}

		 // Getters for fields
		 uint8_t getValue();

		 inline ipv4_option_nophdr* getIpv4_option_nopHeader() { return (ipv4_option_nophdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(ipv4_option_nophdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif