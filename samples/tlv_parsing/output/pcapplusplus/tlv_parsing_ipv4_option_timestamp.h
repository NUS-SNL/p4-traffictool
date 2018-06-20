//Template for addition of new protocol 'ipv4_option_timestamp'

#ifndef P4_IPV4_OPTION_TIMESTAMP_LAYER
#define P4_IPV4_OPTION_TIMESTAMP_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct ipv4_option_timestamphdr{
		uint8_t 	 value;
		uint8_t 	 len;
		-- fill blank here * 	 data;
	};

	#pragma pack(pop)
	class Ipv4_option_timestampLayer: public Layer{
		public:
		 Ipv4_option_timestampLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_IPV4_OPTION_TIMESTAMP;}

		 // Getters for fields
		 uint8_t getValue();
		 uint8_t getLen();
		 -- fill blank here * getData();

		 inline ipv4_option_timestamphdr* getIpv4_option_timestampHeader() { return (ipv4_option_timestamphdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(ipv4_option_timestamphdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif