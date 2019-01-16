#define LOG_MODULE PacketLogModuleAccnt_bal_reqLayer

#include "linear_road_accnt_bal_req.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t Accnt_bal_reqLayer::getTime(){
		uint16_t time;
		accnt_bal_reqhdr* hdrdata = (accnt_bal_reqhdr*)m_Data;
		time = htons(hdrdata->time);
		return time;
	}

	void Accnt_bal_reqLayer::setTime(uint16_t value){
		accnt_bal_reqhdr* hdrdata = (accnt_bal_reqhdr*)m_Data;
		hdrdata->time = htons(value);
	}
	uint32_t Accnt_bal_reqLayer::getVid(){
		uint32_t vid;
		accnt_bal_reqhdr* hdrdata = (accnt_bal_reqhdr*)m_Data;
		vid = htonl(hdrdata->vid);
		return vid;
	}

	void Accnt_bal_reqLayer::setVid(uint32_t value){
		accnt_bal_reqhdr* hdrdata = (accnt_bal_reqhdr*)m_Data;
		hdrdata->vid = htonl(value);
	}
	uint32_t Accnt_bal_reqLayer::getQid(){
		uint32_t qid;
		accnt_bal_reqhdr* hdrdata = (accnt_bal_reqhdr*)m_Data;
		qid = htonl(hdrdata->qid);
		return qid;
	}

	void Accnt_bal_reqLayer::setQid(uint32_t value){
		accnt_bal_reqhdr* hdrdata = (accnt_bal_reqhdr*)m_Data;
		hdrdata->qid = htonl(value);
	}
	void Accnt_bal_reqLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(accnt_bal_reqhdr))
			return;

		m_NextLayer = new PayloadLayer(m_Data + sizeof(accnt_bal_reqhdr), m_DataLen - sizeof(accnt_bal_reqhdr), this, m_Packet);
	}

	std::string Accnt_bal_reqLayer::toString(){ return ""; }

}