//Template for addition of new protocol 'overlay'

#ifndef P4_OVERLAY_LAYER
#define P4_OVERLAY_LAYER

#include <cstring>
#include "Layer.h"
#include "uint24_t.h"
#include "uint40_t.h"
#include "uint48_t.h"
#if defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct overlayhdr{
		uint32_t 	 swip;
	};

	#pragma pack(pop)
	class OverlayLayer: public Layer{
		public:
		OverlayLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_OVERLAY;}
		OverlayLayer(){
			m_DataLen = sizeof(overlayhdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_OVERLAY;
		}

		 // Getters and Setters for fields
		 uint32_t getSwip();
		 void setSwip(uint32_t value);

		 inline overlayhdr* getOverlayHeader() { return (overlayhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(overlayhdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif