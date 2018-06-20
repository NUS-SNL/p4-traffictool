//Template for addition of new protocol 'mri'

#ifndef P4_MRI_LAYER
#define P4_MRI_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct mrihdr{
		uint16_t 	 count;
	};

	#pragma pack(pop)
	class MriLayer: public Layer{
		public:
		 MriLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_MRI;}

		 // Getters for fields
		 uint16_t getCount();

		 inline mrihdr* getMriHeader() { return (mrihdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(mrihdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif