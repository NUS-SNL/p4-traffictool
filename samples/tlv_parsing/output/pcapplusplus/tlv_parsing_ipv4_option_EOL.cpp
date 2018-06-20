#define LOG_MODULE PacketLogModuleIpv4_option_eolLayer

#include "Ipv4_option_eolLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t Ipv4_option_eolLayer::getValue(){
		uint8_t value;
		ipv4_option_eolhdr* hdrdata = (ipv4_option_eolhdr*)m_Data;
		value = (hdrdata->value);
		return value;
	}

	void Ipv4_option_eolLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(ipv4_option_eolhdr))
			return;


	std::string Ipv4_option_eolLayer::toString(){}

