//Template for addition of new protocol 'swids'

#ifndef P4_SWIDS_LAYER
#define P4_SWIDS_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct swidshdr{
		uint32_t 	 swid;
	};

	#pragma pack(pop)
	class SwidsLayer: public Layer{
		public:
		 SwidsLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_SWIDS;}

		 // Getters for fields
		 uint32_t getSwid();

		 inline swidshdr* getSwidsHeader() { return (swidshdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(swidshdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif