#define LOG_MODULE PacketLogModuleMytunnelLayer

#include "basic_tunnel_myTunnel.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t MytunnelLayer::getProto_id(){
		uint16_t proto_id;
		mytunnelhdr* hdrdata = (mytunnelhdr*)m_Data;
		proto_id = htons(hdrdata->proto_id);
		return proto_id;
	}

	void MytunnelLayer::setProto_id(uint16_t value){
		mytunnelhdr* hdrdata = (mytunnelhdr*)m_Data;
		hdrdata->proto_id = htons(value);
	}
	uint16_t MytunnelLayer::getDst_id(){
		uint16_t dst_id;
		mytunnelhdr* hdrdata = (mytunnelhdr*)m_Data;
		dst_id = htons(hdrdata->dst_id);
		return dst_id;
	}

	void MytunnelLayer::setDst_id(uint16_t value){
		mytunnelhdr* hdrdata = (mytunnelhdr*)m_Data;
		hdrdata->dst_id = htons(value);
	}
	void MytunnelLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(mytunnelhdr))
			return;

		mytunnelhdr* hdrdata = getMytunnelHeader();
		uint16_t proto_id = htons(hdrdata->proto_id);
		if (proto_id == 0x0800)
			m_NextLayer = new Ipv4Layer(m_Data+sizeof(mytunnelhdr), m_DataLen - sizeof(mytunnelhdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(mytunnelhdr), m_DataLen - sizeof(mytunnelhdr), this, m_Packet);
	}

	std::string MytunnelLayer::toString(){ return ""; }

}