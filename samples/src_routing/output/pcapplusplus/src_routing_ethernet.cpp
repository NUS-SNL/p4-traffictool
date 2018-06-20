#define LOG_MODULE PacketLogModuleEthernetLayer

#include "EthernetLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint64_t EthernetLayer::getDstaddr(){
		uint64_t dstAddr;
		ethernethdr* hdrdata = (ethernethdr*)m_Data;
		dstAddr = htobe64(hdrdata->dstAddr);
		return dstAddr;
	}

	uint64_t EthernetLayer::getSrcaddr(){
		uint64_t srcAddr;
		ethernethdr* hdrdata = (ethernethdr*)m_Data;
		srcAddr = htobe64(hdrdata->srcAddr);
		return srcAddr;
	}

	uint16_t EthernetLayer::getEthertype(){
		uint16_t etherType;
		ethernethdr* hdrdata = (ethernethdr*)m_Data;
		etherType = htons(hdrdata->etherType);
		return etherType;
	}

	void EthernetLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(ethernethdr))
			return;

		ethernethdr* hdrdata = getEthernetHeader();
		uint16_t etherType = htons(hdrdata->etherType);
		if (etherType == 0x1234)
			m_NextLayer = new SrcroutesLayer(m_Data+sizeof(ethernethdr), m_DataLen - sizeof(ethernethdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(ethernethdr), m_DataLen - sizeof(ethernethdr), this, m_Packet);
	}

	std::string EthernetLayer::toString(){}

