#define LOG_MODULE PacketLogModuleIpv4_option_nopLayer

#include "Ipv4_option_nopLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t Ipv4_option_nopLayer::getValue(){
		uint8_t value;
		ipv4_option_nophdr* hdrdata = (ipv4_option_nophdr*)m_Data;
		value = (hdrdata->value);
		return value;
	}

	void Ipv4_option_nopLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(ipv4_option_nophdr))
			return;


	std::string Ipv4_option_nopLayer::toString(){}

