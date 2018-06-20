//Template for addition of new protocol 'ipv4_option_EOL'

#ifndef P4_IPV4_OPTION_EOL_LAYER
#define P4_IPV4_OPTION_EOL_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct ipv4_option_eolhdr{
		uint8_t 	 value;
	};

	#pragma pack(pop)
	class Ipv4_option_eolLayer: public Layer{
		public:
		 Ipv4_option_eolLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_IPV4_OPTION_EOL;}

		 // Getters for fields
		 uint8_t getValue();

		 inline ipv4_option_eolhdr* getIpv4_option_eolHeader() { return (ipv4_option_eolhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(ipv4_option_eolhdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif