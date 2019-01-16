#define LOG_MODULE PacketLogModuleExpenditure_reportLayer

#include "linear_road_expenditure_report.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t Expenditure_reportLayer::getTime(){
		uint16_t time;
		expenditure_reporthdr* hdrdata = (expenditure_reporthdr*)m_Data;
		time = htons(hdrdata->time);
		return time;
	}

	void Expenditure_reportLayer::setTime(uint16_t value){
		expenditure_reporthdr* hdrdata = (expenditure_reporthdr*)m_Data;
		hdrdata->time = htons(value);
	}
	uint16_t Expenditure_reportLayer::getEmit(){
		uint16_t emit;
		expenditure_reporthdr* hdrdata = (expenditure_reporthdr*)m_Data;
		emit = htons(hdrdata->emit);
		return emit;
	}

	void Expenditure_reportLayer::setEmit(uint16_t value){
		expenditure_reporthdr* hdrdata = (expenditure_reporthdr*)m_Data;
		hdrdata->emit = htons(value);
	}
	uint32_t Expenditure_reportLayer::getQid(){
		uint32_t qid;
		expenditure_reporthdr* hdrdata = (expenditure_reporthdr*)m_Data;
		qid = htonl(hdrdata->qid);
		return qid;
	}

	void Expenditure_reportLayer::setQid(uint32_t value){
		expenditure_reporthdr* hdrdata = (expenditure_reporthdr*)m_Data;
		hdrdata->qid = htonl(value);
	}
	uint16_t Expenditure_reportLayer::getBal(){
		uint16_t bal;
		expenditure_reporthdr* hdrdata = (expenditure_reporthdr*)m_Data;
		bal = htons(hdrdata->bal);
		return bal;
	}

	void Expenditure_reportLayer::setBal(uint16_t value){
		expenditure_reporthdr* hdrdata = (expenditure_reporthdr*)m_Data;
		hdrdata->bal = htons(value);
	}
	void Expenditure_reportLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(expenditure_reporthdr))
			return;

		m_NextLayer = new PayloadLayer(m_Data + sizeof(expenditure_reporthdr), m_DataLen - sizeof(expenditure_reporthdr), this, m_Packet);
	}

	std::string Expenditure_reportLayer::toString(){ return ""; }

}