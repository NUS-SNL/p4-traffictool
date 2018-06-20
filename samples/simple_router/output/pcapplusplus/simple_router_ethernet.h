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
		uint64_t 	 dstAddr;
		uint64_t 	 srcAddr;
		uint16_t 	 etherType;
	};

	#pragma pack(pop)
	class EthernetLayer: public Layer{
		public:
		 EthernetLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_ETHERNET;}

		 // Getters for fields
		 uint64_t getDstaddr();
		 uint64_t getSrcaddr();
		 uint16_t getEthertype();

		 inline ethernethdr* getEthernetHeader() { return (ethernethdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(ethernethdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif