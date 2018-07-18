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

	void IcmpLayer::setType(uint8_t value){
		icmphdr* hdrdata = (icmphdr*)m_Data;
	}
	uint8_t IcmpLayer::getCode(){
		uint8_t code;
		icmphdr* hdrdata = (icmphdr*)m_Data;
		code = (hdrdata->code);
		return code;
	}

	void IcmpLayer::setCode(uint8_t value){
		icmphdr* hdrdata = (icmphdr*)m_Data;
	}
	uint16_t IcmpLayer::getChecksum(){
		uint16_t checksum;
		icmphdr* hdrdata = (icmphdr*)m_Data;
		checksum = htons(hdrdata->checksum);
		return checksum;
	}

	void IcmpLayer::setChecksum(uint16_t value){
		icmphdr* hdrdata = (icmphdr*)m_Data;
	}
	void IcmpLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(icmphdr))
			return;


	std::string IcmpLayer::toString(){}

}