#define LOG_MODULE PacketLogModuleExpenditure_reqLayer

#include "linear_road_expenditure_req.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t Expenditure_reqLayer::getTime(){
		uint16_t time;
		expenditure_reqhdr* hdrdata = (expenditure_reqhdr*)m_Data;
		time = htons(hdrdata->time);
		return time;
	}

	void Expenditure_reqLayer::setTime(uint16_t value){
		expenditure_reqhdr* hdrdata = (expenditure_reqhdr*)m_Data;
		hdrdata->time = htons(value);
	}
	uint32_t Expenditure_reqLayer::getVid(){
		uint32_t vid;
		expenditure_reqhdr* hdrdata = (expenditure_reqhdr*)m_Data;
		vid = htonl(hdrdata->vid);
		return vid;
	}

	void Expenditure_reqLayer::setVid(uint32_t value){
		expenditure_reqhdr* hdrdata = (expenditure_reqhdr*)m_Data;
		hdrdata->vid = htonl(value);
	}
	uint32_t Expenditure_reqLayer::getQid(){
		uint32_t qid;
		expenditure_reqhdr* hdrdata = (expenditure_reqhdr*)m_Data;
		qid = htonl(hdrdata->qid);
		return qid;
	}

	void Expenditure_reqLayer::setQid(uint32_t value){
		expenditure_reqhdr* hdrdata = (expenditure_reqhdr*)m_Data;
		hdrdata->qid = htonl(value);
	}
	uint8_t Expenditure_reqLayer::getXway(){
		uint8_t xway;
		expenditure_reqhdr* hdrdata = (expenditure_reqhdr*)m_Data;
		xway = (hdrdata->xway);
		return xway;
	}

	void Expenditure_reqLayer::setXway(uint8_t value){
		expenditure_reqhdr* hdrdata = (expenditure_reqhdr*)m_Data;
		hdrdata->xway = (value);
	}
	uint8_t Expenditure_reqLayer::getDay(){
		uint8_t day;
		expenditure_reqhdr* hdrdata = (expenditure_reqhdr*)m_Data;
		day = (hdrdata->day);
		return day;
	}

	void Expenditure_reqLayer::setDay(uint8_t value){
		expenditure_reqhdr* hdrdata = (expenditure_reqhdr*)m_Data;
		hdrdata->day = (value);
	}
	void Expenditure_reqLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(expenditure_reqhdr))
			return;

		m_NextLayer = new PayloadLayer(m_Data + sizeof(expenditure_reqhdr), m_DataLen - sizeof(expenditure_reqhdr), this, m_Packet);
	}

	std::string Expenditure_reqLayer::toString(){ return ""; }

}