//Template for addition of new protocol 'ipv4'

#ifndef P4_IPV4_LAYER
#define P4_IPV4_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct ipv4hdr{
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
	class Ipv4Layer: public Layer{
		public:
		 Ipv4Layer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_IPV4;}

		 // Getters and Setters for fields
		 uint8_t getVersion();
		 void setVersion(uint8_t value);
		 uint8_t getIhl();
		 void setIhl(uint8_t value);
		 uint8_t getDiffserv();
		 void setDiffserv(uint8_t value);
		 uint16_t getTotallen();
		 void setTotallen(uint16_t value);
		 uint16_t getIdentification();
		 void setIdentification(uint16_t value);
		 uint8_t getFlags();
		 void setFlags(uint8_t value);
		 uint16_t getFragoffset();
		 void setFragoffset(uint16_t value);
		 uint8_t getTtl();
		 void setTtl(uint8_t value);
		 uint8_t getProtocol();
		 void setProtocol(uint8_t value);
		 uint16_t getHdrchecksum();
		 void setHdrchecksum(uint16_t value);
		 uint32_t getSrcaddr();
		 void setSrcaddr(uint32_t value);
		 uint32_t getDstaddr();
		 void setDstaddr(uint32_t value);

		 inline ipv4hdr* getIpv4Header() { return (ipv4hdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(ipv4hdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif