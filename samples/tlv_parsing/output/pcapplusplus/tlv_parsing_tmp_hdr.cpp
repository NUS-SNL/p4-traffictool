#define LOG_MODULE PacketLogModuleTmp_hdrLayer

#include "Tmp_hdrLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t Tmp_hdrLayer::getValue(){
		uint8_t value;
		tmp_hdrhdr* hdrdata = (tmp_hdrhdr*)m_Data;
		value = (hdrdata->value);
		return value;
	}

	uint8_t Tmp_hdrLayer::getLen(){
		uint8_t len;
		tmp_hdrhdr* hdrdata = (tmp_hdrhdr*)m_Data;
		len = (hdrdata->len);
		return len;
	}

	void Tmp_hdrLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(tmp_hdrhdr))
			return;


	std::string Tmp_hdrLayer::toString(){}

