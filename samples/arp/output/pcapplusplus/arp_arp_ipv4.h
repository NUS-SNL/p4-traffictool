//Template for addition of new protocol 'arp_ipv4'

#ifndef P4_ARP_IPV4_LAYER
#define P4_ARP_IPV4_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct arp_ipv4hdr{
		uint64_t 	 sha;
		uint32_t 	 spa;
		uint64_t 	 tha;
		uint32_t 	 tpa;
	};

	#pragma pack(pop)
	class Arp_ipv4Layer: public Layer{
		public:
		 Arp_ipv4Layer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_ARP_IPV4;}

		 // Getters for fields
		 uint64_t getSha();
		 uint32_t getSpa();
		 uint64_t getTha();
		 uint32_t getTpa();

		 inline arp_ipv4hdr* getArp_ipv4Header() { return (arp_ipv4hdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(arp_ipv4hdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif