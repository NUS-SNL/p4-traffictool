#define LOG_MODULE PacketLogModuleToll_notificationLayer

#include "linear_road_toll_notification.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t Toll_notificationLayer::getTime(){
		uint16_t time;
		toll_notificationhdr* hdrdata = (toll_notificationhdr*)m_Data;
		time = htons(hdrdata->time);
		return time;
	}

	void Toll_notificationLayer::setTime(uint16_t value){
		toll_notificationhdr* hdrdata = (toll_notificationhdr*)m_Data;
		hdrdata->time = htons(value);
	}
	uint32_t Toll_notificationLayer::getVid(){
		uint32_t vid;
		toll_notificationhdr* hdrdata = (toll_notificationhdr*)m_Data;
		vid = htonl(hdrdata->vid);
		return vid;
	}

	void Toll_notificationLayer::setVid(uint32_t value){
		toll_notificationhdr* hdrdata = (toll_notificationhdr*)m_Data;
		hdrdata->vid = htonl(value);
	}
	uint16_t Toll_notificationLayer::getEmit(){
		uint16_t emit;
		toll_notificationhdr* hdrdata = (toll_notificationhdr*)m_Data;
		emit = htons(hdrdata->emit);
		return emit;
	}

	void Toll_notificationLayer::setEmit(uint16_t value){
		toll_notificationhdr* hdrdata = (toll_notificationhdr*)m_Data;
		hdrdata->emit = htons(value);
	}
	uint8_t Toll_notificationLayer::getSpd(){
		uint8_t spd;
		toll_notificationhdr* hdrdata = (toll_notificationhdr*)m_Data;
		spd = (hdrdata->spd);
		return spd;
	}

	void Toll_notificationLayer::setSpd(uint8_t value){
		toll_notificationhdr* hdrdata = (toll_notificationhdr*)m_Data;
		hdrdata->spd = (value);
	}
	uint16_t Toll_notificationLayer::getToll(){
		uint16_t toll;
		toll_notificationhdr* hdrdata = (toll_notificationhdr*)m_Data;
		toll = htons(hdrdata->toll);
		return toll;
	}

	void Toll_notificationLayer::setToll(uint16_t value){
		toll_notificationhdr* hdrdata = (toll_notificationhdr*)m_Data;
		hdrdata->toll = htons(value);
	}
	void Toll_notificationLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(toll_notificationhdr))
			return;

		m_NextLayer = new PayloadLayer(m_Data + sizeof(toll_notificationhdr), m_DataLen - sizeof(toll_notificationhdr), this, m_Packet);
	}

	std::string Toll_notificationLayer::toString(){ return ""; }

}