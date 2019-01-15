#define LOG_MODULE PacketLogModuleSwidsLayer

#include "mri_swids.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint32_t SwidsLayer::getSwid(){
		uint32_t swid;
		swidshdr* hdrdata = (swidshdr*)m_Data;
		swid = htonl(hdrdata->swid);
		return swid;
	}

	void SwidsLayer::setSwid(uint32_t value){
		swidshdr* hdrdata = (swidshdr*)m_Data;
		hdrdata->swid = htonl(value);
	}
	void SwidsLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(swidshdr))
			return;

		swidshdr* hdrdata = getSwidsHeader();
		uint32_t metadata._parser_metadata_remaining1 = htonl(hdrdata->metadata._parser_metadata_remaining1);
		if (metadata._parser_metadata_remaining1 == default)
			m_NextLayer = new SwidsLayer(m_Data+sizeof(swidshdr), m_DataLen - sizeof(swidshdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(swidshdr), m_DataLen - sizeof(swidshdr), this, m_Packet);
	}

	std::string SwidsLayer::toString(){ return ""; }

}