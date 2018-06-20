//Template for addition of new protocol 'tmp_hdr_0'

#ifndef P4_TMP_HDR_0_LAYER
#define P4_TMP_HDR_0_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct tmp_hdr_0hdr{
		-- fill blank here * 	 data;
	};

	#pragma pack(pop)
	class Tmp_hdr_0Layer: public Layer{
		public:
		 Tmp_hdr_0Layer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_TMP_HDR_0;}

		 // Getters for fields
		 -- fill blank here * getData();

		 inline tmp_hdr_0hdr* getTmp_hdr_0Header() { return (tmp_hdr_0hdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(tmp_hdr_0hdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif