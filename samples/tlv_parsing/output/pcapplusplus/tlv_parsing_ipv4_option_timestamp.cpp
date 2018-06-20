#define LOG_MODULE PacketLogModuleIpv4_option_timestampLayer

#include "Ipv4_option_timestampLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t Ipv4_option_timestampLayer::getValue(){
		uint8_t value;
		ipv4_option_timestamphdr* hdrdata = (ipv4_option_timestamphdr*)m_Data;
		value = (hdrdata->value);
		return value;
	}

	uint8_t Ipv4_option_timestampLayer::getLen(){
		uint8_t len;
		ipv4_option_timestamphdr* hdrdata = (ipv4_option_timestamphdr*)m_Data;
		len = (hdrdata->len);
		return len;
	}

	-- fill blank here * Ipv4_option_timestampLayer::getData(){
		-- fill blank here * data;
		ipv4_option_timestamphdr* hdrdata = (ipv4_option_timestamphdr*)m_Data;
		data = -- fill blank here(hdrdata->data);
		return data;
	}

	void Ipv4_option_timestampLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(ipv4_option_timestamphdr))
			return;


	std::string Ipv4_option_timestampLayer::toString(){}

