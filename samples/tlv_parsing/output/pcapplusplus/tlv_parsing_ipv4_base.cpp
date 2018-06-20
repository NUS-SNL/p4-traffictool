#define LOG_MODULE PacketLogModuleIpv4_baseLayer

#include "Ipv4_baseLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t Ipv4_baseLayer::getVersion(){
		uint8_t version;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		version = (hdrdata->version);
		return version;
	}

	uint8_t Ipv4_baseLayer::getIhl(){
		uint8_t ihl;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		ihl = (hdrdata->ihl);
		return ihl;
	}

	uint8_t Ipv4_baseLayer::getDiffserv(){
		uint8_t diffserv;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		diffserv = (hdrdata->diffserv);
		return diffserv;
	}

	uint16_t Ipv4_baseLayer::getTotallen(){
		uint16_t totalLen;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		totalLen = htons(hdrdata->totalLen);
		return totalLen;
	}

	uint16_t Ipv4_baseLayer::getIdentification(){
		uint16_t identification;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		identification = htons(hdrdata->identification);
		return identification;
	}

	uint8_t Ipv4_baseLayer::getFlags(){
		uint8_t flags;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		flags = (hdrdata->flags);
		return flags;
	}

	uint16_t Ipv4_baseLayer::getFragoffset(){
		uint16_t fragOffset;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		fragOffset = htons(hdrdata->fragOffset);
		return fragOffset;
	}

	uint8_t Ipv4_baseLayer::getTtl(){
		uint8_t ttl;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		ttl = (hdrdata->ttl);
		return ttl;
	}

	uint8_t Ipv4_baseLayer::getProtocol(){
		uint8_t protocol;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		protocol = (hdrdata->protocol);
		return protocol;
	}

	uint16_t Ipv4_baseLayer::getHdrchecksum(){
		uint16_t hdrChecksum;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		hdrChecksum = htons(hdrdata->hdrChecksum);
		return hdrChecksum;
	}

	uint32_t Ipv4_baseLayer::getSrcaddr(){
		uint32_t srcAddr;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		srcAddr = htonl(hdrdata->srcAddr);
		return srcAddr;
	}

	uint32_t Ipv4_baseLayer::getDstaddr(){
		uint32_t dstAddr;
		ipv4_basehdr* hdrdata = (ipv4_basehdr*)m_Data;
		dstAddr = htonl(hdrdata->dstAddr);
		return dstAddr;
	}

	void Ipv4_baseLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(ipv4_basehdr))
			return;

		ipv4_basehdr* hdrdata = getIpv4_baseHeader();
		uint8_t ihl = (hdrdata->ihl);
		if (ihl == default)
			m_NextLayer = new ScalarsLayer(m_Data+sizeof(ipv4_basehdr), m_DataLen - sizeof(ipv4_basehdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(ipv4_basehdr), m_DataLen - sizeof(ipv4_basehdr), this, m_Packet);
	}

	std::string Ipv4_baseLayer::toString(){}

