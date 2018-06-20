//Template for addition of new protocol 'cpu_header'

#ifndef P4_CPU_HEADER_LAYER
#define P4_CPU_HEADER_LAYER

#include "Layer.h"
#ifdef defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
	#pragma pack(push,1)
	struct cpu_headerhdr{
		uint64_t 	 preamble;
		uint8_t 	 device;
		uint8_t 	 reason;
		uint8_t 	 if_index;
	};

	#pragma pack(pop)
	class Cpu_headerLayer: public Layer{
		public:
		 Cpu_headerLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_CPU_HEADER;}

		 // Getters for fields
		 uint64_t getPreamble();
		 uint8_t getDevice();
		 uint8_t getReason();
		 uint8_t getIf_index();

		 inline cpu_headerhdr* getCpu_headerHeader() { return (cpu_headerhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(cpu_headerhdr); }

		 void computeCalculateField() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif