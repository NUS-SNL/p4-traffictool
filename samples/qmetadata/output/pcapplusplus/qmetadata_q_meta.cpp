#define LOG_MODULE PacketLogModuleQ_metaLayer

#include "qmetadata_q_meta.h"
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

    void Q_metaLayer::setFlow_id(uint16_t value){
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        hdrdata->flow_id = htons(value);
    }
    uint64_t Q_metaLayer::getIngress_global_tstamp(){
        uint64_t ingress_global_tstamp;
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        ingress_global_tstamp = htobe64(hdrdata->ingress_global_tstamp);
        return ingress_global_tstamp;
    }

    void Q_metaLayer::setIngress_global_tstamp(uint64_t value){
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        hdrdata->ingress_global_tstamp = htobe64(value);
    }
    uint64_t Q_metaLayer::getEgress_global_tstamp(){
        uint64_t egress_global_tstamp;
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        egress_global_tstamp = htobe64(hdrdata->egress_global_tstamp);
        return egress_global_tstamp;
    }

    void Q_metaLayer::setEgress_global_tstamp(uint64_t value){
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        hdrdata->egress_global_tstamp = htobe64(value);
    }
    uint16_t Q_metaLayer::getMarkbit(){
        uint16_t markbit;
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        markbit = htons(hdrdata->markbit);
        return markbit;
    }

    void Q_metaLayer::setMarkbit(uint16_t value){
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        hdrdata->markbit = htons(value);
    }
    uint32_t Q_metaLayer::getEnq_qdepth(){
        uint24_t enq_qdepth;
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        UINT24_HTON(enq_qdepth,hdrdata->enq_qdepth);
        uint32_t return_val = UINT24_GET(enq_qdepth);
        return return_val;
    }

    void Q_metaLayer::setEnq_qdepth(uint32_t value){
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        uint24_t value_set;
        UINT24_SET(value_set, value);
        UINT24_HTON(hdrdata->enq_qdepth, value_set);
    }
    uint32_t Q_metaLayer::getDeq_qdepth(){
        uint24_t deq_qdepth;
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        UINT24_HTON(deq_qdepth,hdrdata->deq_qdepth);
        uint32_t return_val = UINT24_GET(deq_qdepth);
        return return_val;
    }

    void Q_metaLayer::setDeq_qdepth(uint32_t value){
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        uint24_t value_set;
        UINT24_SET(value_set, value);
        UINT24_HTON(hdrdata->deq_qdepth, value_set);
    }
    void Q_metaLayer::parseNextLayer(){
        if (m_DataLen <= sizeof(q_metahdr))
            return;

    }

    std::string Q_metaLayer::toString(){ return ""; }

}