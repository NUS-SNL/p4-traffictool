//Template for addition of new protocol 'accnt_bal'

#ifndef P4_ACCNT_BAL_LAYER
#define P4_ACCNT_BAL_LAYER

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
	struct accnt_balhdr{
		uint16_t 	 time;
		uint32_t 	 vid;
		uint16_t 	 emit;
		uint32_t 	 qid;
		uint32_t 	 bal;
	};

	#pragma pack(pop)
	class Accnt_balLayer: public Layer{
		public:
		Accnt_balLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_ACCNT_BAL;}
		Accnt_balLayer(){
			m_DataLen = sizeof(accnt_balhdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_ACCNT_BAL;
		}

		 // Getters and Setters for fields
		 uint16_t getTime();
		 void setTime(uint16_t value);
		 uint32_t getVid();
		 void setVid(uint32_t value);
		 uint16_t getEmit();
		 void setEmit(uint16_t value);
		 uint32_t getQid();
		 void setQid(uint32_t value);
		 uint32_t getBal();
		 void setBal(uint32_t value);

		 inline accnt_balhdr* getAccnt_balHeader() { return (accnt_balhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(accnt_balhdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif