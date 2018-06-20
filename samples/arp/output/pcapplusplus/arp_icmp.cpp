#define LOG_MODULE PacketLogModuleIcmpLayer

#include "IcmpLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t IcmpLayer::getType(){
		uint8_t type;
		icmphdr* hdrdata = (icmphdr*)m_Data;
		type = (hdrdata->type);
		return type;
	}

	uint8_t IcmpLayer::getCode(){
		uint8_t code;
		icmphdr* hdrdata = (icmphdr*)m_Data;
		code = (hdrdata->code);
		return code;
	}

	uint16_t IcmpLayer::getChecksum(){
		uint16_t checksum;
		icmphdr* hdrdata = (icmphdr*)m_Data;
		checksum = htons(hdrdata->checksum);
		return checksum;
	}

	void IcmpLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(icmphdr))
			return;


	std::string IcmpLayer::toString(){}

