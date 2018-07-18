#define LOG_MODULE PacketLogModuleArpLayer

#include "ArpLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t ArpLayer::getHtype(){
		uint16_t htype;
		arphdr* hdrdata = (arphdr*)m_Data;
		htype = htons(hdrdata->htype);
		return htype;
	}

	void ArpLayer::setHtype(uint16_t value){
		arphdr* hdrdata = (arphdr*)m_Data;
	}
	uint16_t ArpLayer::getPtype(){
		uint16_t ptype;
		arphdr* hdrdata = (arphdr*)m_Data;
		ptype = htons(hdrdata->ptype);
		return ptype;
	}

	void ArpLayer::setPtype(uint16_t value){
		arphdr* hdrdata = (arphdr*)m_Data;
	}
	uint8_t ArpLayer::getHlen(){
		uint8_t hlen;
		arphdr* hdrdata = (arphdr*)m_Data;
		hlen = (hdrdata->hlen);
		return hlen;
	}

	void ArpLayer::setHlen(uint8_t value){
		arphdr* hdrdata = (arphdr*)m_Data;
	}
	uint8_t ArpLayer::getPlen(){
		uint8_t plen;
		arphdr* hdrdata = (arphdr*)m_Data;
		plen = (hdrdata->plen);
		return plen;
	}

	void ArpLayer::setPlen(uint8_t value){
		arphdr* hdrdata = (arphdr*)m_Data;
	}
	uint16_t ArpLayer::getOper(){
		uint16_t oper;
		arphdr* hdrdata = (arphdr*)m_Data;
		oper = htons(hdrdata->oper);
		return oper;
	}

	void ArpLayer::setOper(uint16_t value){
		arphdr* hdrdata = (arphdr*)m_Data;
	}
	void ArpLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(arphdr))
			return;

		arphdr* hdrdata = getArpHeader();
		uint16_t htype = htons(hdrdata->htype);
		if (htype == 0x000108000604)
			m_NextLayer = new Arp_ipv4Layer(m_Data+sizeof(arphdr), m_DataLen - sizeof(arphdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(arphdr), m_DataLen - sizeof(arphdr), this, m_Packet);
	}

	std::string ArpLayer::toString(){}

}