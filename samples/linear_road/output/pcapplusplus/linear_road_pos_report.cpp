#define LOG_MODULE PacketLogModulePos_reportLayer

#include "linear_road_pos_report.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t Pos_reportLayer::getTime(){
		uint16_t time;
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		time = htons(hdrdata->time);
		return time;
	}

	void Pos_reportLayer::setTime(uint16_t value){
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		hdrdata->time = htons(value);
	}
	uint32_t Pos_reportLayer::getVid(){
		uint32_t vid;
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		vid = htonl(hdrdata->vid);
		return vid;
	}

	void Pos_reportLayer::setVid(uint32_t value){
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		hdrdata->vid = htonl(value);
	}
	uint8_t Pos_reportLayer::getSpd(){
		uint8_t spd;
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		spd = (hdrdata->spd);
		return spd;
	}

	void Pos_reportLayer::setSpd(uint8_t value){
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		hdrdata->spd = (value);
	}
	uint8_t Pos_reportLayer::getXway(){
		uint8_t xway;
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		xway = (hdrdata->xway);
		return xway;
	}

	void Pos_reportLayer::setXway(uint8_t value){
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		hdrdata->xway = (value);
	}
	uint8_t Pos_reportLayer::getLane(){
		uint8_t lane;
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		lane = (hdrdata->lane);
		return lane;
	}

	void Pos_reportLayer::setLane(uint8_t value){
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		hdrdata->lane = (value);
	}
	uint8_t Pos_reportLayer::getDir(){
		uint8_t dir;
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		dir = (hdrdata->dir);
		return dir;
	}

	void Pos_reportLayer::setDir(uint8_t value){
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		hdrdata->dir = (value);
	}
	uint8_t Pos_reportLayer::getSeg(){
		uint8_t seg;
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		seg = (hdrdata->seg);
		return seg;
	}

	void Pos_reportLayer::setSeg(uint8_t value){
		pos_reporthdr* hdrdata = (pos_reporthdr*)m_Data;
		hdrdata->seg = (value);
	}
	void Pos_reportLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(pos_reporthdr))
			return;

		m_NextLayer = new PayloadLayer(m_Data + sizeof(pos_reporthdr), m_DataLen - sizeof(pos_reporthdr), this, m_Packet);
	}

	std::string Pos_reportLayer::toString(){ return ""; }

}