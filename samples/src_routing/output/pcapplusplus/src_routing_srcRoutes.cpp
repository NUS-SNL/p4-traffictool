#define LOG_MODULE PacketLogModuleSrcroutesLayer

#include "SrcroutesLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t SrcroutesLayer::getBos(){
		uint8_t bos;
		srcrouteshdr* hdrdata = (srcrouteshdr*)m_Data;
		bos = (hdrdata->bos);
		return bos;
	}

	uint16_t SrcroutesLayer::getPort(){
		uint16_t port;
		srcrouteshdr* hdrdata = (srcrouteshdr*)m_Data;
		port = htons(hdrdata->port);
		return port;
	}

	void SrcroutesLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(srcrouteshdr))
			return;

		srcrouteshdr* hdrdata = getSrcroutesHeader();
		uint8_t bos = (hdrdata->bos);
		if (bos == 0x01)
			m_NextLayer = new Ipv4Layer(m_Data+sizeof(srcrouteshdr), m_DataLen - sizeof(srcrouteshdr), this, m_Packet);
		else if (bos == default)
			m_NextLayer = new SrcroutesLayer(m_Data+sizeof(srcrouteshdr), m_DataLen - sizeof(srcrouteshdr), this, m_Packet);

	std::string SrcroutesLayer::toString(){}

