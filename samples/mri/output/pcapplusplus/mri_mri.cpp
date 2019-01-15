#define LOG_MODULE PacketLogModuleMriLayer

#include "mri_mri.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t MriLayer::getCount(){
		uint16_t count;
		mrihdr* hdrdata = (mrihdr*)m_Data;
		count = htons(hdrdata->count);
		return count;
	}

	void MriLayer::setCount(uint16_t value){
		mrihdr* hdrdata = (mrihdr*)m_Data;
		hdrdata->count = htons(value);
	}
	void MriLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(mrihdr))
			return;

		mrihdr* hdrdata = getMriHeader();
		uint16_t count = htons(hdrdata->count);
		if (count == default)
			m_NextLayer = new SwidsLayer(m_Data+sizeof(mrihdr), m_DataLen - sizeof(mrihdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(mrihdr), m_DataLen - sizeof(mrihdr), this, m_Packet);
	}

	std::string MriLayer::toString(){ return ""; }

}