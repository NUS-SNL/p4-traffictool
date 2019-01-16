//Template for addition of new protocol 'nc_value_6'

#ifndef P4_NC_VALUE_6_LAYER
#define P4_NC_VALUE_6_LAYER

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
	struct nc_value_6hdr{
		uint32_t 	 value_6_1;
		uint32_t 	 value_6_2;
		uint32_t 	 value_6_3;
		uint32_t 	 value_6_4;
	};

	#pragma pack(pop)
	class Nc_value_6Layer: public Layer{
		public:
		Nc_value_6Layer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_NC_VALUE_6;}
		Nc_value_6Layer(){
			m_DataLen = sizeof(nc_value_6hdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_NC_VALUE_6;
		}

		 // Getters and Setters for fields
		 uint32_t getValue_6_1();
		 void setValue_6_1(uint32_t value);
		 uint32_t getValue_6_2();
		 void setValue_6_2(uint32_t value);
		 uint32_t getValue_6_3();
		 void setValue_6_3(uint32_t value);
		 uint32_t getValue_6_4();
		 void setValue_6_4(uint32_t value);

		 inline nc_value_6hdr* getNc_value_6Header() { return (nc_value_6hdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(nc_value_6hdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif