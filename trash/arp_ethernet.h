//Template for addition of new protocol 'ethernet'

#ifndef P4_ETHERNET_LAYER
#define P4_ETHERNET_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct ethernethdr{
		uint48_t 	 dstAddr;
		uint48_t 	 srcAddr;
		uint16_t 	 etherType;
	};

	#pragma pack(pop)
	class EthernetLayer: public Layer{
		public:
		 EthernetLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_ETHERNET;}

		 // Getters and Setters for fields
		 uint48_t getDstaddr();
		 void setDstaddr(uint64_t value);
		 uint48_t getSrcaddr();
		 void setSrcaddr(uint64_t value);
		 uint16_t getEthertype();
		 void setEthertype(uint16_t value);

		 inline ethernethdr* getEthernetHeader() { return (ethernethdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(ethernethdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif