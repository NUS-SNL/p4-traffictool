#define LOG_MODULE PacketLogModuleCpu_headerLayer

#include "Cpu_headerLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint64_t Cpu_headerLayer::getPreamble(){
		uint64_t preamble;
		cpu_headerhdr* hdrdata = (cpu_headerhdr*)m_Data;
		preamble = htobe64(hdrdata->preamble);
		return preamble;
	}

	uint8_t Cpu_headerLayer::getDevice(){
		uint8_t device;
		cpu_headerhdr* hdrdata = (cpu_headerhdr*)m_Data;
		device = (hdrdata->device);
		return device;
	}

	uint8_t Cpu_headerLayer::getReason(){
		uint8_t reason;
		cpu_headerhdr* hdrdata = (cpu_headerhdr*)m_Data;
		reason = (hdrdata->reason);
		return reason;
	}

	uint8_t Cpu_headerLayer::getIf_index(){
		uint8_t if_index;
		cpu_headerhdr* hdrdata = (cpu_headerhdr*)m_Data;
		if_index = (hdrdata->if_index);
		return if_index;
	}

	void Cpu_headerLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(cpu_headerhdr))
			return;


	std::string Cpu_headerLayer::toString(){}

