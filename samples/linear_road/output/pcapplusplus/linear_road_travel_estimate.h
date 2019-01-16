//Template for addition of new protocol 'travel_estimate'

#ifndef P4_TRAVEL_ESTIMATE_LAYER
#define P4_TRAVEL_ESTIMATE_LAYER

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
	struct travel_estimatehdr{
		uint32_t 	 qid;
		uint16_t 	 travel_time;
		uint16_t 	 toll;
	};

	#pragma pack(pop)
	class Travel_estimateLayer: public Layer{
		public:
		Travel_estimateLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_TRAVEL_ESTIMATE;}
		Travel_estimateLayer(){
			m_DataLen = sizeof(travel_estimatehdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_TRAVEL_ESTIMATE;
		}

		 // Getters and Setters for fields
		 uint32_t getQid();
		 void setQid(uint32_t value);
		 uint16_t getTravel_time();
		 void setTravel_time(uint16_t value);
		 uint16_t getToll();
		 void setToll(uint16_t value);

		 inline travel_estimatehdr* getTravel_estimateHeader() { return (travel_estimatehdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(travel_estimatehdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif