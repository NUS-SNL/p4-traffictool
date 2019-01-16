//Template for addition of new protocol 'toll_notification'

#ifndef P4_TOLL_NOTIFICATION_LAYER
#define P4_TOLL_NOTIFICATION_LAYER

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
	struct toll_notificationhdr{
		uint16_t 	 time;
		uint32_t 	 vid;
		uint16_t 	 emit;
		uint8_t 	 spd;
		uint16_t 	 toll;
	};

	#pragma pack(pop)
	class Toll_notificationLayer: public Layer{
		public:
		Toll_notificationLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_TOLL_NOTIFICATION;}
		Toll_notificationLayer(){
			m_DataLen = sizeof(toll_notificationhdr);
			m_Data = new uint8_t[m_DataLen];
			memset(m_Data, 0, m_DataLen);
			m_Protocol = P4_TOLL_NOTIFICATION;
		}

		 // Getters and Setters for fields
		 uint16_t getTime();
		 void setTime(uint16_t value);
		 uint32_t getVid();
		 void setVid(uint32_t value);
		 uint16_t getEmit();
		 void setEmit(uint16_t value);
		 uint8_t getSpd();
		 void setSpd(uint8_t value);
		 uint16_t getToll();
		 void setToll(uint16_t value);

		 inline toll_notificationhdr* getToll_notificationHeader() { return (toll_notificationhdr*)m_Data; }

		 void parseNextLayer();

		 inline size_t getHeaderLen() { return sizeof(toll_notificationhdr); }

		 void computeCalculateFields() {}

		 std::string toString();

		 OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

	};
}
#endif