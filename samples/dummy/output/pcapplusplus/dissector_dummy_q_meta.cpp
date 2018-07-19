#define LOG_MODULE PacketLogModuleQ_metaLayer

#include "Q_metaLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t Q_metaLayer::getFlow_id(){
		uint16_t flow_id;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		flow_id = htons(hdrdata->flow_id);
		return flow_id;
	}

	uint16_t Q_metaLayer::get_pad0(){
		uint16_t _pad0;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		_pad0 = htons(hdrdata->_pad0);
		return _pad0;
	}

	uint64_t Q_metaLayer::getIngress_global_tstamp(){
		uint64_t ingress_global_tstamp;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		ingress_global_tstamp = htobe64(hdrdata->ingress_global_tstamp);
		return ingress_global_tstamp;
	}

	uint16_t Q_metaLayer::get_pad1(){
		uint16_t _pad1;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		_pad1 = htons(hdrdata->_pad1);
		return _pad1;
	}

	uint64_t Q_metaLayer::getEgress_global_tstamp(){
		uint64_t egress_global_tstamp;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		egress_global_tstamp = htobe64(hdrdata->egress_global_tstamp);
		return egress_global_tstamp;
	}

	uint16_t Q_metaLayer::get_spare_pad_bits(){
		uint16_t _spare_pad_bits;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		_spare_pad_bits = htons(hdrdata->_spare_pad_bits);
		return _spare_pad_bits;
	}

	uint8_t Q_metaLayer::getMarkbit(){
		uint8_t markbit;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		markbit = (hdrdata->markbit);
		return markbit;
	}

	uint16_t Q_metaLayer::get_pad2(){
		uint16_t _pad2;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		_pad2 = htons(hdrdata->_pad2);
		return _pad2;
	}

	uint32_t Q_metaLayer::getEnq_qdepth(){
		uint32_t enq_qdepth;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		enq_qdepth = htonl(hdrdata->enq_qdepth);
		return enq_qdepth;
	}

	uint16_t Q_metaLayer::get_pad3(){
		uint16_t _pad3;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		_pad3 = htons(hdrdata->_pad3);
		return _pad3;
	}

	uint32_t Q_metaLayer::getDeq_qdepth(){
		uint32_t deq_qdepth;
		q_metahdr* hdrdata = (q_metahdr*)m_Data;
		deq_qdepth = htonl(hdrdata->deq_qdepth);
		return deq_qdepth;
	}

	void Q_metaLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(q_metahdr))
			return;


	std::string Q_metaLayer::toString(){}

