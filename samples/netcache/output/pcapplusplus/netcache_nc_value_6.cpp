#define LOG_MODULE PacketLogModuleNc_value_6Layer

#include "netcache_nc_value_6.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint32_t Nc_value_6Layer::getValue_6_1(){
		uint32_t value_6_1;
		nc_value_6hdr* hdrdata = (nc_value_6hdr*)m_Data;
		value_6_1 = htonl(hdrdata->value_6_1);
		return value_6_1;
	}

	void Nc_value_6Layer::setValue_6_1(uint32_t value){
		nc_value_6hdr* hdrdata = (nc_value_6hdr*)m_Data;
		hdrdata->value_6_1 = htonl(value);
	}
	uint32_t Nc_value_6Layer::getValue_6_2(){
		uint32_t value_6_2;
		nc_value_6hdr* hdrdata = (nc_value_6hdr*)m_Data;
		value_6_2 = htonl(hdrdata->value_6_2);
		return value_6_2;
	}

	void Nc_value_6Layer::setValue_6_2(uint32_t value){
		nc_value_6hdr* hdrdata = (nc_value_6hdr*)m_Data;
		hdrdata->value_6_2 = htonl(value);
	}
	uint32_t Nc_value_6Layer::getValue_6_3(){
		uint32_t value_6_3;
		nc_value_6hdr* hdrdata = (nc_value_6hdr*)m_Data;
		value_6_3 = htonl(hdrdata->value_6_3);
		return value_6_3;
	}

	void Nc_value_6Layer::setValue_6_3(uint32_t value){
		nc_value_6hdr* hdrdata = (nc_value_6hdr*)m_Data;
		hdrdata->value_6_3 = htonl(value);
	}
	uint32_t Nc_value_6Layer::getValue_6_4(){
		uint32_t value_6_4;
		nc_value_6hdr* hdrdata = (nc_value_6hdr*)m_Data;
		value_6_4 = htonl(hdrdata->value_6_4);
		return value_6_4;
	}

	void Nc_value_6Layer::setValue_6_4(uint32_t value){
		nc_value_6hdr* hdrdata = (nc_value_6hdr*)m_Data;
		hdrdata->value_6_4 = htonl(value);
	}
	void Nc_value_6Layer::parseNextLayer(){
		if (m_DataLen <= sizeof(nc_value_6hdr))
			return;

		m_NextLayer = new PayloadLayer(m_Data + sizeof(nc_value_6hdr), m_DataLen - sizeof(nc_value_6hdr), this, m_Packet);
	}

	std::string Nc_value_6Layer::toString(){ return ""; }

}