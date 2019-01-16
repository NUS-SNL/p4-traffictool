//Template for addition of new protocol 'nc_load'

#ifndef P4_NC_LOAD_LAYER
#define P4_NC_LOAD_LAYER

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
	struct nc_loadhdr{
		uint32_t 	 load_1;
		uint32_t 	 load_2;
		uint32_t 	 load_3;
		uint32_t 	 load_4;
	};

	#pragma pack(pop)
	class Nc_loadLayer: public Layer{
		public:
		Nc_loadLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_NC_LOAD;}
		Nc_loadLayer(){
			m_DataLen = sizeof(nc_loadhdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_NC_LOAD;
		}

		 // Getters and Setters for fields
		 uint32_t getLoad_1();
		 void setLoad_1(uint32_t value);
		 uint32_t getLoad_2();
		 void setLoad_2(uint32_t value);
		 uint32_t getLoad_3();
		 void setLoad_3(uint32_t value);
		 uint32_t getLoad_4();
		 void setLoad_4(uint32_t value);

		 inline nc_loadhdr* getNc_loadHeader() { return (nc_loadhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(nc_loadhdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif