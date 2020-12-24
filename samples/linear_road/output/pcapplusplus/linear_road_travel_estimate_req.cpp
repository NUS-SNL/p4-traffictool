#define LOG_MODULE PacketLogModuleTravel_estimate_reqLayer

#include "linear_road_travel_estimate_req.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint16_t Travel_estimate_reqLayer::getTime(){
        uint16_t time;
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        time = htons(hdrdata->time);
        return time;
    }

    void Travel_estimate_reqLayer::setTime(uint16_t value){
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        hdrdata->time = htons(value);
    }
    uint32_t Travel_estimate_reqLayer::getQid(){
        uint32_t qid;
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        qid = htonl(hdrdata->qid);
        return qid;
    }

    void Travel_estimate_reqLayer::setQid(uint32_t value){
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        hdrdata->qid = htonl(value);
    }
    uint8_t Travel_estimate_reqLayer::getXway(){
        uint8_t xway;
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        xway = (hdrdata->xway);
        return xway;
    }

    void Travel_estimate_reqLayer::setXway(uint8_t value){
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        hdrdata->xway = (value);
    }
    uint8_t Travel_estimate_reqLayer::getSeg_init(){
        uint8_t seg_init;
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        seg_init = (hdrdata->seg_init);
        return seg_init;
    }

    void Travel_estimate_reqLayer::setSeg_init(uint8_t value){
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        hdrdata->seg_init = (value);
    }
    uint8_t Travel_estimate_reqLayer::getSeg_end(){
        uint8_t seg_end;
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        seg_end = (hdrdata->seg_end);
        return seg_end;
    }

    void Travel_estimate_reqLayer::setSeg_end(uint8_t value){
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        hdrdata->seg_end = (value);
    }
    uint8_t Travel_estimate_reqLayer::getDow(){
        uint8_t dow;
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        dow = (hdrdata->dow);
        return dow;
    }

    void Travel_estimate_reqLayer::setDow(uint8_t value){
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        hdrdata->dow = (value);
    }
    uint8_t Travel_estimate_reqLayer::getTod(){
        uint8_t tod;
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        tod = (hdrdata->tod);
        return tod;
    }

    void Travel_estimate_reqLayer::setTod(uint8_t value){
        travel_estimate_reqhdr* hdrdata = (travel_estimate_reqhdr*)m_Data;
        hdrdata->tod = (value);
    }
    void Travel_estimate_reqLayer::parseNextLayer(){
        if (m_DataLen <= sizeof(travel_estimate_reqhdr))
            return;

    }

    std::string Travel_estimate_reqLayer::toString(){ return ""; }

}