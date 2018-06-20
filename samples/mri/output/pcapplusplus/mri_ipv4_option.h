//Template for addition of new protocol 'ipv4_option'

#ifndef P4_IPV4_OPTION_LAYER
#define P4_IPV4_OPTION_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
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

		 // Getters for fields
		 uint8_t getCopyflag();
		 uint8_t getOptclass();
		 uint8_t getOption();
		 uint8_t getOptionlength();

		 inline ipv4_optionhdr* getIpv4_optionHeader() { return (ipv4_optionhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(ipv4_optionhdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif