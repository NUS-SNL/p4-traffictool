//Template for addition of new protocol 'ipv4_base'

#ifndef P4_IPV4_BASE_LAYER
#define P4_IPV4_BASE_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct ipv4_basehdr{
		uint8_t 	 version;
		uint8_t 	 ihl;
		uint8_t 	 diffserv;
		uint16_t 	 totalLen;
		uint16_t 	 identification;
		uint8_t 	 flags;
		uint16_t 	 fragOffset;
		uint8_t 	 ttl;
		uint8_t 	 protocol;
		uint16_t 	 hdrChecksum;
		uint32_t 	 srcAddr;
		uint32_t 	 dstAddr;
	};

	#pragma pack(pop)
	class Ipv4_baseLayer: public Layer{
		public:
		 Ipv4_baseLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_IPV4_BASE;}

		 // Getters for fields
		 uint8_t getVersion();
		 uint8_t getIhl();
		 uint8_t getDiffserv();
		 uint16_t getTotallen();
		 uint16_t getIdentification();
		 uint8_t getFlags();
		 uint16_t getFragoffset();
		 uint8_t getTtl();
		 uint8_t getProtocol();
		 uint16_t getHdrchecksum();
		 uint32_t getSrcaddr();
		 uint32_t getDstaddr();

		 inline ipv4_basehdr* getIpv4_baseHeader() { return (ipv4_basehdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(ipv4_basehdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif