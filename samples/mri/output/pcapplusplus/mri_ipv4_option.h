//Template for addition of new protocol 'ipv4_option'

#ifndef P4_IPV4_OPTION_LAYER
#define P4_IPV4_OPTION_LAYER

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
	struct ipv4_optionhdr{
		uint8_t 	 copyFlag;
		uint8_t 	 optClass;
		uint8_t 	 option;
		uint8_t 	 optionLength;
	};

	#pragma pack(pop)
	class Ipv4_optionLayer: public Layer{
		public:
		Ipv4_optionLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_IPV4_OPTION;}
		Ipv4_optionLayer(){
			m_DataLen = sizeof(ipv4_optionhdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_IPV4_OPTION;
		}

		 // Getters and Setters for fields
		 uint8_t getCopyflag();
		 void setCopyflag(uint8_t value);
		 uint8_t getOptclass();
		 void setOptclass(uint8_t value);
		 uint8_t getOption();
		 void setOption(uint8_t value);
		 uint8_t getOptionlength();
		 void setOptionlength(uint8_t value);

		 inline ipv4_optionhdr* getIpv4_optionHeader() { return (ipv4_optionhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(ipv4_optionhdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif