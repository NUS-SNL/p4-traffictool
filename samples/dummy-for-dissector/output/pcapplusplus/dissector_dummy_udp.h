//Template for addition of new protocol 'udp'

#ifndef P4_UDP_LAYER
#define P4_UDP_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct udphdr{
		uint16_t 	 srcPort;
		uint16_t 	 dstPort;
		uint16_t 	 hdr_length;
		uint16_t 	 checksum;
	};

	#pragma pack(pop)
	class UdpLayer: public Layer{
		public:
		 UdpLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_UDP;}

		 // Getters for fields
		 uint16_t getSrcport();
		 uint16_t getDstport();
		 uint16_t getHdr_length();
		 uint16_t getChecksum();

		 inline udphdr* getUdpHeader() { return (udphdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(udphdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif