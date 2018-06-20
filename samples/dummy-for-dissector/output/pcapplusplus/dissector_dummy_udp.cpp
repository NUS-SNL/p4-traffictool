#define LOG_MODULE PacketLogModuleUdpLayer

#include "UdpLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t UdpLayer::getSrcport(){
		uint16_t srcPort;
		udphdr* hdrdata = (udphdr*)m_Data;
		srcPort = htons(hdrdata->srcPort);
		return srcPort;
	}

	uint16_t UdpLayer::getDstport(){
		uint16_t dstPort;
		udphdr* hdrdata = (udphdr*)m_Data;
		dstPort = htons(hdrdata->dstPort);
		return dstPort;
	}

	uint16_t UdpLayer::getHdr_length(){
		uint16_t hdr_length;
		udphdr* hdrdata = (udphdr*)m_Data;
		hdr_length = htons(hdrdata->hdr_length);
		return hdr_length;
	}

	uint16_t UdpLayer::getChecksum(){
		uint16_t checksum;
		udphdr* hdrdata = (udphdr*)m_Data;
		checksum = htons(hdrdata->checksum);
		return checksum;
	}

	void UdpLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(udphdr))
			return;

		udphdr* hdrdata = getUdpHeader();
		uint16_t dstPort = htons(hdrdata->dstPort);
		if (dstPort == 0x1e61)
			m_NextLayer = new Q_metaLayer(m_Data+sizeof(udphdr), m_DataLen - sizeof(udphdr), this, m_Packet);
		else if (dstPort == 0x22b8)
			m_NextLayer = new SnapshotLayer(m_Data+sizeof(udphdr), m_DataLen - sizeof(udphdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(udphdr), m_DataLen - sizeof(udphdr), this, m_Packet);
	}

	std::string UdpLayer::toString(){}

