#define LOG_MODULE PacketLogModuleOverlayLayer

#include "netchain_overlay.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint32_t OverlayLayer::getSwip(){
		uint32_t swip;
		overlayhdr* hdrdata = (overlayhdr*)m_Data;
		swip = htonl(hdrdata->swip);
		return swip;
	}

	void OverlayLayer::setSwip(uint32_t value){
		overlayhdr* hdrdata = (overlayhdr*)m_Data;
		hdrdata->swip = htonl(value);
	}
	void OverlayLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(overlayhdr))
			return;

		overlayhdr* hdrdata = getOverlayHeader();
		uint32_t swip = htonl(hdrdata->swip);
		if (swip == 0x00000000)
			m_NextLayer = new Nc_hdrLayer(m_Data+sizeof(overlayhdr), m_DataLen - sizeof(overlayhdr), this, m_Packet);
		else if (swip == default)
			m_NextLayer = new OverlayLayer(m_Data+sizeof(overlayhdr), m_DataLen - sizeof(overlayhdr), this, m_Packet);
	}

	std::string OverlayLayer::toString(){ return ""; }

}