#define LOG_MODULE PacketLogModuleQ_metaLayer

#include "basic_postcards_q_meta.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
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
    uint32_t Q_metaLayer::getDeq_timedelta(){
        uint32_t deq_timedelta;
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        deq_timedelta = htonl(hdrdata->deq_timedelta);
        return deq_timedelta;
    }

    void Q_metaLayer::setDeq_timedelta(uint32_t value){
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        hdrdata->deq_timedelta = htonl(value);
    }
    uint32_t Q_metaLayer::getEnq_timestamp(){
        uint32_t enq_timestamp;
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        enq_timestamp = htonl(hdrdata->enq_timestamp);
        return enq_timestamp;
    }

    void Q_metaLayer::setEnq_timestamp(uint32_t value){
        q_metahdr* hdrdata = (q_metahdr*)m_Data;
        hdrdata->enq_timestamp = htonl(value);
    }
    void Q_metaLayer::parseNextLayer(){
        if (m_DataLen <= sizeof(q_metahdr))
            return;

    }

    std::string Q_metaLayer::toString(){ return ""; }

}