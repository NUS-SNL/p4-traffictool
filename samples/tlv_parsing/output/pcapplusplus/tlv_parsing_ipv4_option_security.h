//Template for addition of new protocol 'ipv4_option_security'

#ifndef P4_IPV4_OPTION_SECURITY_LAYER
#define P4_IPV4_OPTION_SECURITY_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct ipv4_option_securityhdr{
		uint8_t 	 value;
		uint8_t 	 len;
		-- fill blank here 72 	 security;
	};

	#pragma pack(pop)
	class Ipv4_option_securityLayer: public Layer{
		public:
		 Ipv4_option_securityLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_IPV4_OPTION_SECURITY;}

		 // Getters for fields
		 uint8_t getValue();
		 uint8_t getLen();
		 -- fill blank here 72 getSecurity();

		 inline ipv4_option_securityhdr* getIpv4_option_securityHeader() { return (ipv4_option_securityhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(ipv4_option_securityhdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif