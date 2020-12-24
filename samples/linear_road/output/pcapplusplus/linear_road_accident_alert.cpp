#define LOG_MODULE PacketLogModuleAccident_alertLayer

#include "linear_road_accident_alert.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint16_t Accident_alertLayer::getTime(){
        uint16_t time;
        accident_alerthdr* hdrdata = (accident_alerthdr*)m_Data;
        time = htons(hdrdata->time);
        return time;
    }

    void Accident_alertLayer::setTime(uint16_t value){
        accident_alerthdr* hdrdata = (accident_alerthdr*)m_Data;
        hdrdata->time = htons(value);
    }
    uint32_t Accident_alertLayer::getVid(){
        uint32_t vid;
        accident_alerthdr* hdrdata = (accident_alerthdr*)m_Data;
        vid = htonl(hdrdata->vid);
        return vid;
    }

    void Accident_alertLayer::setVid(uint32_t value){
        accident_alerthdr* hdrdata = (accident_alerthdr*)m_Data;
        hdrdata->vid = htonl(value);
    }
    uint16_t Accident_alertLayer::getEmit(){
        uint16_t emit;
        accident_alerthdr* hdrdata = (accident_alerthdr*)m_Data;
        emit = htons(hdrdata->emit);
        return emit;
    }

    void Accident_alertLayer::setEmit(uint16_t value){
        accident_alerthdr* hdrdata = (accident_alerthdr*)m_Data;
        hdrdata->emit = htons(value);
    }
    uint8_t Accident_alertLayer::getSeg(){
        uint8_t seg;
        accident_alerthdr* hdrdata = (accident_alerthdr*)m_Data;
        seg = (hdrdata->seg);
        return seg;
    }

    void Accident_alertLayer::setSeg(uint8_t value){
        accident_alerthdr* hdrdata = (accident_alerthdr*)m_Data;
        hdrdata->seg = (value);
    }
    void Accident_alertLayer::parseNextLayer(){
        if (m_DataLen <= sizeof(accident_alerthdr))
            return;

    }

    std::string Accident_alertLayer::toString(){ return ""; }

}