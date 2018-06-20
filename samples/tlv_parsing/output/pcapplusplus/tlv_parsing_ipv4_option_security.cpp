#define LOG_MODULE PacketLogModuleIpv4_option_securityLayer

#include "Ipv4_option_securityLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t Ipv4_option_securityLayer::getValue(){
		uint8_t value;
		ipv4_option_securityhdr* hdrdata = (ipv4_option_securityhdr*)m_Data;
		value = (hdrdata->value);
		return value;
	}

	uint8_t Ipv4_option_securityLayer::getLen(){
		uint8_t len;
		ipv4_option_securityhdr* hdrdata = (ipv4_option_securityhdr*)m_Data;
		len = (hdrdata->len);
		return len;
	}

	-- fill blank here 72 Ipv4_option_securityLayer::getSecurity(){
		-- fill blank here 72 security;
		ipv4_option_securityhdr* hdrdata = (ipv4_option_securityhdr*)m_Data;
		security = -- fill blank here(hdrdata->security);
		return security;
	}

	void Ipv4_option_securityLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(ipv4_option_securityhdr))
			return;


	std::string Ipv4_option_securityLayer::toString(){}

