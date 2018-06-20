#define LOG_MODULE PacketLogModuleArp_ipv4Layer

#include "Arp_ipv4Layer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint64_t Arp_ipv4Layer::getSha(){
		uint64_t sha;
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
		sha = htobe64(hdrdata->sha);
		return sha;
	}

	uint32_t Arp_ipv4Layer::getSpa(){
		uint32_t spa;
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
		spa = htonl(hdrdata->spa);
		return spa;
	}

	uint64_t Arp_ipv4Layer::getTha(){
		uint64_t tha;
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
		tha = htobe64(hdrdata->tha);
		return tha;
	}

	uint32_t Arp_ipv4Layer::getTpa(){
		uint32_t tpa;
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
		tpa = htonl(hdrdata->tpa);
		return tpa;
	}

	void Arp_ipv4Layer::parseNextLayer(){
		if (m_DataLen <= sizeof(arp_ipv4hdr))
			return;


	std::string Arp_ipv4Layer::toString(){}

