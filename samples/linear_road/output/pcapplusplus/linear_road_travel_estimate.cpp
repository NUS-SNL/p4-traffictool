#define LOG_MODULE PacketLogModuleTravel_estimateLayer

#include "linear_road_travel_estimate.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint32_t Travel_estimateLayer::getQid(){
        uint32_t qid;
        travel_estimatehdr* hdrdata = (travel_estimatehdr*)m_Data;
        qid = htonl(hdrdata->qid);
        return qid;
    }

    void Travel_estimateLayer::setQid(uint32_t value){
        travel_estimatehdr* hdrdata = (travel_estimatehdr*)m_Data;
        hdrdata->qid = htonl(value);
    }
    uint16_t Travel_estimateLayer::getTravel_time(){
        uint16_t travel_time;
        travel_estimatehdr* hdrdata = (travel_estimatehdr*)m_Data;
        travel_time = htons(hdrdata->travel_time);
        return travel_time;
    }

    void Travel_estimateLayer::setTravel_time(uint16_t value){
        travel_estimatehdr* hdrdata = (travel_estimatehdr*)m_Data;
        hdrdata->travel_time = htons(value);
    }
    uint16_t Travel_estimateLayer::getToll(){
        uint16_t toll;
        travel_estimatehdr* hdrdata = (travel_estimatehdr*)m_Data;
        toll = htons(hdrdata->toll);
        return toll;
    }

    void Travel_estimateLayer::setToll(uint16_t value){
        travel_estimatehdr* hdrdata = (travel_estimatehdr*)m_Data;
        hdrdata->toll = htons(value);
    }
    void Travel_estimateLayer::parseNextLayer(){
        if (m_DataLen <= sizeof(travel_estimatehdr))
            return;

    }

    std::string Travel_estimateLayer::toString(){ return ""; }

}