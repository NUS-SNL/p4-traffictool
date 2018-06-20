//Template for addition of new protocol 'tcp'

#ifndef P4_TCP_LAYER
#define P4_TCP_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct tcphdr{
		uint16_t 	 srcPort;
		uint16_t 	 dstPort;
		uint32_t 	 seqNo;
		uint32_t 	 ackNo;
		uint8_t 	 dataOffset;
		uint8_t 	 res;
		uint8_t 	 flags;
		uint16_t 	 window;
		uint16_t 	 checksum;
		uint16_t 	 urgentPtr;
	};

	#pragma pack(pop)
	class TcpLayer: public Layer{
		public:
		 TcpLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_TCP;}

		 // Getters for fields
		 uint16_t getSrcport();
		 uint16_t getDstport();
		 uint32_t getSeqno();
		 uint32_t getAckno();
		 uint8_t getDataoffset();
		 uint8_t getRes();
		 uint8_t getFlags();
		 uint16_t getWindow();
		 uint16_t getChecksum();
		 uint16_t getUrgentptr();

		 inline tcphdr* getTcpHeader() { return (tcphdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(tcphdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif