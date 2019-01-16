#define LOG_MODULE PacketLogModuleNc_hdrLayer

#include "netcache_nc_hdr.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t Nc_hdrLayer::getOp(){
		uint8_t op;
		nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
		op = (hdrdata->op);
		return op;
	}

	void Nc_hdrLayer::setOp(uint8_t value){
		nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
		hdrdata->op = (value);
	}
	uint64_t Nc_hdrLayer::getKey(){
		uint64_t key;
		nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
		key = htobe64(hdrdata->key);
		return key;
	}

	void Nc_hdrLayer::setKey(uint64_t value){
		nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
		hdrdata->key = htobe64(value);
	}
	void Nc_hdrLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(nc_hdrhdr))
			return;

		nc_hdrhdr* hdrdata = getNc_hdrHeader();
		uint8_t op = (hdrdata->op);
		if (op == 0x01)
			m_NextLayer = new Parse_valueLayer(m_Data+sizeof(nc_hdrhdr), m_DataLen - sizeof(nc_hdrhdr), this, m_Packet);
		else if (op == 0x02)
			m_NextLayer = new Nc_loadLayer(m_Data+sizeof(nc_hdrhdr), m_DataLen - sizeof(nc_hdrhdr), this, m_Packet);
		else if (op == 0x09)
			m_NextLayer = new Parse_valueLayer(m_Data+sizeof(nc_hdrhdr), m_DataLen - sizeof(nc_hdrhdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(nc_hdrhdr), m_DataLen - sizeof(nc_hdrhdr), this, m_Packet);
	}

	std::string Nc_hdrLayer::toString(){ return ""; }

}