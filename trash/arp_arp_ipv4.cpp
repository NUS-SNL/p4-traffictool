#define LOG_MODULE PacketLogModuleArp_ipv4Layer

#include "Arp_ipv4Layer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint48_t Arp_ipv4Layer::getSha(){
		uint48_t sha;
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
		UINT48_HTON(hdrdata->sha,sha);
		return sha;
	}

	void Arp_ipv4Layer::setSha(uint64_t value){
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
		UINT48_SET(value,hdrdata->sha);
	}
	uint32_t Arp_ipv4Layer::getSpa(){
		uint32_t spa;
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
		spa = htonl(hdrdata->spa);
		return spa;
	}

	void Arp_ipv4Layer::setSpa(uint32_t value){
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
	}
	uint48_t Arp_ipv4Layer::getTha(){
		uint48_t tha;
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
		UINT48_HTON(hdrdata->tha,tha);
		return tha;
	}

	void Arp_ipv4Layer::setTha(uint64_t value){
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
		UINT48_SET(value,hdrdata->tha);
	}
	uint32_t Arp_ipv4Layer::getTpa(){
		uint32_t tpa;
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
		tpa = htonl(hdrdata->tpa);
		return tpa;
	}

	void Arp_ipv4Layer::setTpa(uint32_t value){
		arp_ipv4hdr* hdrdata = (arp_ipv4hdr*)m_Data;
	}
	void Arp_ipv4Layer::parseNextLayer(){
		if (m_DataLen <= sizeof(arp_ipv4hdr))
			return;


	std::string Arp_ipv4Layer::toString(){}

}