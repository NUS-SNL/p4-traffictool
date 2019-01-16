#define LOG_MODULE PacketLogModuleNc_value_7Layer

#include "netcache_nc_value_7.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint32_t Nc_value_7Layer::getValue_7_1(){
		uint32_t value_7_1;
		nc_value_7hdr* hdrdata = (nc_value_7hdr*)m_Data;
		value_7_1 = htonl(hdrdata->value_7_1);
		return value_7_1;
	}

	void Nc_value_7Layer::setValue_7_1(uint32_t value){
		nc_value_7hdr* hdrdata = (nc_value_7hdr*)m_Data;
		hdrdata->value_7_1 = htonl(value);
	}
	uint32_t Nc_value_7Layer::getValue_7_2(){
		uint32_t value_7_2;
		nc_value_7hdr* hdrdata = (nc_value_7hdr*)m_Data;
		value_7_2 = htonl(hdrdata->value_7_2);
		return value_7_2;
	}

	void Nc_value_7Layer::setValue_7_2(uint32_t value){
		nc_value_7hdr* hdrdata = (nc_value_7hdr*)m_Data;
		hdrdata->value_7_2 = htonl(value);
	}
	uint32_t Nc_value_7Layer::getValue_7_3(){
		uint32_t value_7_3;
		nc_value_7hdr* hdrdata = (nc_value_7hdr*)m_Data;
		value_7_3 = htonl(hdrdata->value_7_3);
		return value_7_3;
	}

	void Nc_value_7Layer::setValue_7_3(uint32_t value){
		nc_value_7hdr* hdrdata = (nc_value_7hdr*)m_Data;
		hdrdata->value_7_3 = htonl(value);
	}
	uint32_t Nc_value_7Layer::getValue_7_4(){
		uint32_t value_7_4;
		nc_value_7hdr* hdrdata = (nc_value_7hdr*)m_Data;
		value_7_4 = htonl(hdrdata->value_7_4);
		return value_7_4;
	}

	void Nc_value_7Layer::setValue_7_4(uint32_t value){
		nc_value_7hdr* hdrdata = (nc_value_7hdr*)m_Data;
		hdrdata->value_7_4 = htonl(value);
	}
	void Nc_value_7Layer::parseNextLayer(){
		if (m_DataLen <= sizeof(nc_value_7hdr))
			return;

		m_NextLayer = new PayloadLayer(m_Data + sizeof(nc_value_7hdr), m_DataLen - sizeof(nc_value_7hdr), this, m_Packet);
	}

	std::string Nc_value_7Layer::toString(){ return ""; }

}