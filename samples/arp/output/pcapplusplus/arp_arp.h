//Template for addition of new protocol 'arp'

#ifndef P4_ARP_LAYER
#define P4_ARP_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct arphdr{
		uint16_t 	 htype;
		uint16_t 	 ptype;
		uint8_t 	 hlen;
		uint8_t 	 plen;
		uint16_t 	 oper;
	};

	#pragma pack(pop)
	class ArpLayer: public Layer{
		public:
		 ArpLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_ARP;}

		 // Getters for fields
		 uint16_t getHtype();
		 uint16_t getPtype();
		 uint8_t getHlen();
		 uint8_t getPlen();
		 uint16_t getOper();

		 inline arphdr* getArpHeader() { return (arphdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(arphdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif