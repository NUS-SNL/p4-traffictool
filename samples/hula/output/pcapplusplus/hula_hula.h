//Template for addition of new protocol 'hula'

#ifndef P4_HULA_LAYER
#define P4_HULA_LAYER

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
	struct hulahdr{
		uint8_t 	 dir;
		uint16_t 	 qdepth;
		uint32_t 	 digest;
	};

	#pragma pack(pop)
	class HulaLayer: public Layer{
		public:
		HulaLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_HULA;}
		HulaLayer(){
			m_DataLen = sizeof(hulahdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_HULA;
		}

		 // Getters and Setters for fields
		 uint8_t getDir();
		 void setDir(uint8_t value);
		 uint16_t getQdepth();
		 void setQdepth(uint16_t value);
		 uint32_t getDigest();
		 void setDigest(uint32_t value);

		 inline hulahdr* getHulaHeader() { return (hulahdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(hulahdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif