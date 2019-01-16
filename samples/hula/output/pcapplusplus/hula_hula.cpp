#define LOG_MODULE PacketLogModuleHulaLayer

#include "hula_hula.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t HulaLayer::getDir(){
		uint8_t dir;
		hulahdr* hdrdata = (hulahdr*)m_Data;
		dir = (hdrdata->dir);
		return dir;
	}

	void HulaLayer::setDir(uint8_t value){
		hulahdr* hdrdata = (hulahdr*)m_Data;
		hdrdata->dir = (value);
	}
	uint16_t HulaLayer::getQdepth(){
		uint16_t qdepth;
		hulahdr* hdrdata = (hulahdr*)m_Data;
		qdepth = htons(hdrdata->qdepth);
		return qdepth;
	}

	void HulaLayer::setQdepth(uint16_t value){
		hulahdr* hdrdata = (hulahdr*)m_Data;
		hdrdata->qdepth = htons(value);
	}
	uint32_t HulaLayer::getDigest(){
		uint32_t digest;
		hulahdr* hdrdata = (hulahdr*)m_Data;
		digest = htonl(hdrdata->digest);
		return digest;
	}

	void HulaLayer::setDigest(uint32_t value){
		hulahdr* hdrdata = (hulahdr*)m_Data;
		hdrdata->digest = htonl(value);
	}
	void HulaLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(hulahdr))
			return;

		m_NextLayer = new PayloadLayer(m_Data + sizeof(hulahdr), m_DataLen - sizeof(hulahdr), this, m_Packet);
	}

	std::string HulaLayer::toString(){ return ""; }

}