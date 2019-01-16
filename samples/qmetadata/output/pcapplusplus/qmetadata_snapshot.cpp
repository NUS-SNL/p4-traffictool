#define LOG_MODULE PacketLogModuleSnapshotLayer

#include "qmetadata_snapshot.h"
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

	void SnapshotLayer::setIngress_global_tstamp_hi_16(uint16_t value){
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		hdrdata->ingress_global_tstamp_hi_16 = htons(value);
	}
	uint32_t SnapshotLayer::getIngress_global_tstamp_lo_32(){
		uint32_t ingress_global_tstamp_lo_32;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		ingress_global_tstamp_lo_32 = htonl(hdrdata->ingress_global_tstamp_lo_32);
		return ingress_global_tstamp_lo_32;
	}

	void SnapshotLayer::setIngress_global_tstamp_lo_32(uint32_t value){
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		hdrdata->ingress_global_tstamp_lo_32 = htonl(value);
	}
	uint32_t SnapshotLayer::getEgress_global_tstamp_lo_32(){
		uint32_t egress_global_tstamp_lo_32;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		egress_global_tstamp_lo_32 = htonl(hdrdata->egress_global_tstamp_lo_32);
		return egress_global_tstamp_lo_32;
	}

	void SnapshotLayer::setEgress_global_tstamp_lo_32(uint32_t value){
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		hdrdata->egress_global_tstamp_lo_32 = htonl(value);
	}
	uint32_t SnapshotLayer::getEnq_qdepth(){
		uint32_t enq_qdepth;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		enq_qdepth = htonl(hdrdata->enq_qdepth);
		return enq_qdepth;
	}

	void SnapshotLayer::setEnq_qdepth(uint32_t value){
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		hdrdata->enq_qdepth = htonl(value);
	}
	uint32_t SnapshotLayer::getDeq_qdepth(){
		uint32_t deq_qdepth;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		deq_qdepth = htonl(hdrdata->deq_qdepth);
		return deq_qdepth;
	}

	void SnapshotLayer::setDeq_qdepth(uint32_t value){
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		hdrdata->deq_qdepth = htonl(value);
	}
	uint64_t SnapshotLayer::getOrig_egress_global_tstamp(){
		uint64_t orig_egress_global_tstamp;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		orig_egress_global_tstamp = htobe64(hdrdata->orig_egress_global_tstamp);
		return orig_egress_global_tstamp;
	}

	void SnapshotLayer::setOrig_egress_global_tstamp(uint64_t value){
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		hdrdata->orig_egress_global_tstamp = htobe64(value);
	}
	uint64_t SnapshotLayer::getNew_egress_global_tstamp(){
		uint64_t new_egress_global_tstamp;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		new_egress_global_tstamp = htobe64(hdrdata->new_egress_global_tstamp);
		return new_egress_global_tstamp;
	}

	void SnapshotLayer::setNew_egress_global_tstamp(uint64_t value){
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		hdrdata->new_egress_global_tstamp = htobe64(value);
	}
	uint32_t SnapshotLayer::getNew_enq_tstamp(){
		uint32_t new_enq_tstamp;
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		new_enq_tstamp = htonl(hdrdata->new_enq_tstamp);
		return new_enq_tstamp;
	}

	void SnapshotLayer::setNew_enq_tstamp(uint32_t value){
		snapshothdr* hdrdata = (snapshothdr*)m_Data;
		hdrdata->new_enq_tstamp = htonl(value);
	}
	void SnapshotLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(snapshothdr))
			return;

		m_NextLayer = new PayloadLayer(m_Data + sizeof(snapshothdr), m_DataLen - sizeof(snapshothdr), this, m_Packet);
	}

	std::string SnapshotLayer::toString(){ return ""; }

}