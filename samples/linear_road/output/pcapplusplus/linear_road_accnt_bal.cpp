#define LOG_MODULE PacketLogModuleAccnt_balLayer

#include "linear_road_accnt_bal.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint16_t Accnt_balLayer::getTime(){
        uint16_t time;
        accnt_balhdr* hdrdata = (accnt_balhdr*)m_Data;
        time = htons(hdrdata->time);
        return time;
    }

    void Accnt_balLayer::setTime(uint16_t value){
        accnt_balhdr* hdrdata = (accnt_balhdr*)m_Data;
        hdrdata->time = htons(value);
    }
    uint32_t Accnt_balLayer::getVid(){
        uint32_t vid;
        accnt_balhdr* hdrdata = (accnt_balhdr*)m_Data;
        vid = htonl(hdrdata->vid);
        return vid;
    }

    void Accnt_balLayer::setVid(uint32_t value){
        accnt_balhdr* hdrdata = (accnt_balhdr*)m_Data;
        hdrdata->vid = htonl(value);
    }
    uint16_t Accnt_balLayer::getEmit(){
        uint16_t emit;
        accnt_balhdr* hdrdata = (accnt_balhdr*)m_Data;
        emit = htons(hdrdata->emit);
        return emit;
    }

    void Accnt_balLayer::setEmit(uint16_t value){
        accnt_balhdr* hdrdata = (accnt_balhdr*)m_Data;
        hdrdata->emit = htons(value);
    }
    uint32_t Accnt_balLayer::getQid(){
        uint32_t qid;
        accnt_balhdr* hdrdata = (accnt_balhdr*)m_Data;
        qid = htonl(hdrdata->qid);
        return qid;
    }

    void Accnt_balLayer::setQid(uint32_t value){
        accnt_balhdr* hdrdata = (accnt_balhdr*)m_Data;
        hdrdata->qid = htonl(value);
    }
    uint32_t Accnt_balLayer::getBal(){
        uint32_t bal;
        accnt_balhdr* hdrdata = (accnt_balhdr*)m_Data;
        bal = htonl(hdrdata->bal);
        return bal;
    }

    void Accnt_balLayer::setBal(uint32_t value){
        accnt_balhdr* hdrdata = (accnt_balhdr*)m_Data;
        hdrdata->bal = htonl(value);
    }
    void Accnt_balLayer::parseNextLayer(){
        if (m_DataLen <= sizeof(accnt_balhdr))
            return;

    }

    std::string Accnt_balLayer::toString(){ return ""; }

}