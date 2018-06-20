//Template for addition of new protocol 'icmp'

#ifndef P4_ICMP_LAYER
#define P4_ICMP_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct icmphdr{
		uint8_t 	 type;
		uint8_t 	 code;
		uint16_t 	 checksum;
	};

	#pragma pack(pop)
	class IcmpLayer: public Layer{
		public:
		 IcmpLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_ICMP;}

		 // Getters for fields
		 uint8_t getType();
		 uint8_t getCode();
		 uint16_t getChecksum();

		 inline icmphdr* getIcmpHeader() { return (icmphdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(icmphdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif