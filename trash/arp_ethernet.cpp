#define LOG_MODULE PacketLogModuleEthernetLayer

#include "EthernetLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint48_t EthernetLayer::getDstaddr(){
		uint48_t dstAddr;
		ethernethdr* hdrdata = (ethernethdr*)m_Data;
		UINT48_HTON(hdrdata->dstAddr,dstAddr);
		return dstAddr;
	}

	void EthernetLayer::setDstaddr(uint64_t value){
		ethernethdr* hdrdata = (ethernethdr*)m_Data;
		UINT48_SET(value,hdrdata->dstAddr);
	}
	uint48_t EthernetLayer::getSrcaddr(){
		uint48_t srcAddr;
		ethernethdr* hdrdata = (ethernethdr*)m_Data;
		UINT48_HTON(hdrdata->srcAddr,srcAddr);
		return srcAddr;
	}

	void EthernetLayer::setSrcaddr(uint64_t value){
		ethernethdr* hdrdata = (ethernethdr*)m_Data;
		UINT48_SET(value,hdrdata->srcAddr);
	}
	uint16_t EthernetLayer::getEthertype(){
		uint16_t etherType;
		ethernethdr* hdrdata = (ethernethdr*)m_Data;
		etherType = htons(hdrdata->etherType);
		return etherType;
	}

	void EthernetLayer::setEthertype(uint16_t value){
		ethernethdr* hdrdata = (ethernethdr*)m_Data;
	}
	void EthernetLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(ethernethdr))
			return;

		ethernethdr* hdrdata = getEthernetHeader();
		uint16_t etherType = htons(hdrdata->etherType);
		if (etherType == 0x0800)
			m_NextLayer = new Ipv4Layer(m_Data+sizeof(ethernethdr), m_DataLen - sizeof(ethernethdr), this, m_Packet);
		else if (etherType == 0x0806)
			m_NextLayer = new ArpLayer(m_Data+sizeof(ethernethdr), m_DataLen - sizeof(ethernethdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(ethernethdr), m_DataLen - sizeof(ethernethdr), this, m_Packet);
	}

	std::string EthernetLayer::toString(){}

}