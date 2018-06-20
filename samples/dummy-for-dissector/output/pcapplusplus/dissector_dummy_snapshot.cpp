#define LOG_MODULE PacketLogModuleSnapshotLayer

#include "SnapshotLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t SnapshotLayer::getIngress_global_tstamp_hi_16(){
		uint16_t ingress_global_tstamp_hi_16;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		ingress_global_tstamp_hi_16 = htons(hdrdata->ingress_global_tstamp_hi_16);
		return ingress_global_tstamp_hi_16;
	}

	uint32_t SnapshotLayer::getIngress_global_tstamp_lo_32(){
		uint32_t ingress_global_tstamp_lo_32;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		ingress_global_tstamp_lo_32 = htonl(hdrdata->ingress_global_tstamp_lo_32);
		return ingress_global_tstamp_lo_32;
	}

	uint32_t SnapshotLayer::getEgress_global_tstamp_lo_32(){
		uint32_t egress_global_tstamp_lo_32;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		egress_global_tstamp_lo_32 = htonl(hdrdata->egress_global_tstamp_lo_32);
		return egress_global_tstamp_lo_32;
	}

	uint32_t SnapshotLayer::getEnq_qdepth(){
		uint32_t enq_qdepth;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		enq_qdepth = htonl(hdrdata->enq_qdepth);
		return enq_qdepth;
	}

	uint32_t SnapshotLayer::getDeq_qdepth(){
		uint32_t deq_qdepth;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		deq_qdepth = htonl(hdrdata->deq_qdepth);
		return deq_qdepth;
	}

	uint16_t SnapshotLayer::get_pad0(){
		uint16_t _pad0;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		_pad0 = htons(hdrdata->_pad0);
		return _pad0;
	}

	uint64_t SnapshotLayer::getOrig_egress_global_tstamp(){
		uint64_t orig_egress_global_tstamp;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		orig_egress_global_tstamp = htobe64(hdrdata->orig_egress_global_tstamp);
		return orig_egress_global_tstamp;
	}

	uint16_t SnapshotLayer::get_pad1(){
		uint16_t _pad1;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		_pad1 = htons(hdrdata->_pad1);
		return _pad1;
	}

	uint64_t SnapshotLayer::getNew_egress_global_tstamp(){
		uint64_t new_egress_global_tstamp;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		new_egress_global_tstamp = htobe64(hdrdata->new_egress_global_tstamp);
		return new_egress_global_tstamp;
	}

	uint32_t SnapshotLayer::getNew_enq_tstamp(){
		uint32_t new_enq_tstamp;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		new_enq_tstamp = htonl(hdrdata->new_enq_tstamp);
		return new_enq_tstamp;
	}

	void SnapshotLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(snapshothdr))
			return;


	std::string SnapshotLayer::toString(){}

