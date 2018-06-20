#define LOG_MODULE PacketLogModuleIpv4_optionLayer

#include "Ipv4_optionLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint8_t Ipv4_optionLayer::getCopyflag(){
		uint8_t copyFlag;
		ipv4_optionhdr* hdrdata = (ipv4_optionhdr*)m_Data;
		copyFlag = (hdrdata->copyFlag);
		return copyFlag;
	}

	uint8_t Ipv4_optionLayer::getOptclass(){
		uint8_t optClass;
		ipv4_optionhdr* hdrdata = (ipv4_optionhdr*)m_Data;
		optClass = (hdrdata->optClass);
		return optClass;
	}

	uint8_t Ipv4_optionLayer::getOption(){
		uint8_t option;
		ipv4_optionhdr* hdrdata = (ipv4_optionhdr*)m_Data;
		option = (hdrdata->option);
		return option;
	}

	uint8_t Ipv4_optionLayer::getOptionlength(){
		uint8_t optionLength;
		ipv4_optionhdr* hdrdata = (ipv4_optionhdr*)m_Data;
		optionLength = (hdrdata->optionLength);
		return optionLength;
	}

	void Ipv4_optionLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(ipv4_optionhdr))
			return;

		ipv4_optionhdr* hdrdata = getIpv4_optionHeader();
		uint8_t option = (hdrdata->option);
		if (option == 0x1f)
			m_NextLayer = new MriLayer(m_Data+sizeof(ipv4_optionhdr), m_DataLen - sizeof(ipv4_optionhdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(ipv4_optionhdr), m_DataLen - sizeof(ipv4_optionhdr), this, m_Packet);
	}

	std::string Ipv4_optionLayer::toString(){}

