#define LOG_MODULE PacketLogModuleHdr_metaLayer

#include "basic_postcards_hdr_meta.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint64_t Hdr_metaLayer::getMac_dstaddr(){
		uint48_t mac_dstAddr;
		hdr_metahdr* hdrdata = (hdr_metahdr*)m_Data;
		UINT48_HTON(mac_dstAddr,hdrdata->mac_dstAddr);
		uint64_t return_val = UINT48_GET(mac_dstAddr);
		return return_val;
	}

	void Hdr_metaLayer::setMac_dstaddr(uint64_t value){
		hdr_metahdr* hdrdata = (hdr_metahdr*)m_Data;
		uint48_t value_set;
		UINT48_SET(value_set, value);
		UINT48_HTON(hdrdata->mac_dstAddr, value_set);
	}
	uint64_t Hdr_metaLayer::getMac_srcaddr(){
		uint48_t mac_srcAddr;
		hdr_metahdr* hdrdata = (hdr_metahdr*)m_Data;
		UINT48_HTON(mac_srcAddr,hdrdata->mac_srcAddr);
		uint64_t return_val = UINT48_GET(mac_srcAddr);
		return return_val;
	}

	void Hdr_metaLayer::setMac_srcaddr(uint64_t value){
		hdr_metahdr* hdrdata = (hdr_metahdr*)m_Data;
		uint48_t value_set;
		UINT48_SET(value_set, value);
		UINT48_HTON(hdrdata->mac_srcAddr, value_set);
	}
	uint32_t Hdr_metaLayer::getIp_srcaddr(){
		uint32_t ip_srcAddr;
		hdr_metahdr* hdrdata = (hdr_metahdr*)m_Data;
		ip_srcAddr = htonl(hdrdata->ip_srcAddr);
		return ip_srcAddr;
	}

	void Hdr_metaLayer::setIp_srcaddr(uint32_t value){
		hdr_metahdr* hdrdata = (hdr_metahdr*)m_Data;
		hdrdata->ip_srcAddr = htonl(value);
	}
	uint32_t Hdr_metaLayer::getIp_dstaddr(){
		uint32_t ip_dstAddr;
		hdr_metahdr* hdrdata = (hdr_metahdr*)m_Data;
		ip_dstAddr = htonl(hdrdata->ip_dstAddr);
		return ip_dstAddr;
	}

	void Hdr_metaLayer::setIp_dstaddr(uint32_t value){
		hdr_metahdr* hdrdata = (hdr_metahdr*)m_Data;
		hdrdata->ip_dstAddr = htonl(value);
	}
	uint8_t Hdr_metaLayer::getIp_protocol(){
		uint8_t ip_protocol;
		hdr_metahdr* hdrdata = (hdr_metahdr*)m_Data;
		ip_protocol = (hdrdata->ip_protocol);
		return ip_protocol;
	}

	void Hdr_metaLayer::setIp_protocol(uint8_t value){
		hdr_metahdr* hdrdata = (hdr_metahdr*)m_Data;
		hdrdata->ip_protocol = (value);
	}
	void Hdr_metaLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(hdr_metahdr))
			return;

		m_NextLayer = new PayloadLayer(m_Data + sizeof(hdr_metahdr), m_DataLen - sizeof(hdr_metahdr), this, m_Packet);
	}

	std::string Hdr_metaLayer::toString(){ return ""; }

}