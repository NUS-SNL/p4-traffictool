//Template for addition of new protocol 'tmp_hdr'

#ifndef P4_TMP_HDR_LAYER
#define P4_TMP_HDR_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct tmp_hdrhdr{
		uint8_t 	 value;
		uint8_t 	 len;
	};

	#pragma pack(pop)
	class Tmp_hdrLayer: public Layer{
		public:
		 Tmp_hdrLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_TMP_HDR;}

		 // Getters for fields
		 uint8_t getValue();
		 uint8_t getLen();

		 inline tmp_hdrhdr* getTmp_hdrHeader() { return (tmp_hdrhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(tmp_hdrhdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif