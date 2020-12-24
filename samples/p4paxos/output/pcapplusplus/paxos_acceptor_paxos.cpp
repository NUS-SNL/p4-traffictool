#define LOG_MODULE PacketLogModulePaxosLayer

#include "paxos_acceptor_paxos.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint8_t PaxosLayer::getMsgtype(){
        uint8_t msgtype;
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        msgtype = (hdrdata->msgtype);
        return msgtype;
    }

    void PaxosLayer::setMsgtype(uint8_t value){
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        hdrdata->msgtype = (value);
    }
    uint16_t PaxosLayer::getInstance(){
        uint16_t instance;
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        instance = htons(hdrdata->instance);
        return instance;
    }

    void PaxosLayer::setInstance(uint16_t value){
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        hdrdata->instance = htons(value);
    }
    uint8_t PaxosLayer::getRound(){
        uint8_t round;
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        round = (hdrdata->round);
        return round;
    }

    void PaxosLayer::setRound(uint8_t value){
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        hdrdata->round = (value);
    }
    uint8_t PaxosLayer::getVround(){
        uint8_t vround;
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        vround = (hdrdata->vround);
        return vround;
    }

    void PaxosLayer::setVround(uint8_t value){
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        hdrdata->vround = (value);
    }
    uint64_t PaxosLayer::getAcceptor(){
        uint64_t acceptor;
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        acceptor = htobe64(hdrdata->acceptor);
        return acceptor;
    }

    void PaxosLayer::setAcceptor(uint64_t value){
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        hdrdata->acceptor = htobe64(value);
    }
    None PaxosLayer::getValue(){
        -- fill blank here 512 value;
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        value = -- fill blank here(hdrdata->value);
        return value;
    }

    void PaxosLayer::setValue(None value){
        paxoshdr* hdrdata = (paxoshdr*)m_Data;
        hdrdata->value = -- fill blank here(value);
    }
    void PaxosLayer::parseNextLayer(){
        if (m_DataLen <= sizeof(paxoshdr))
            return;

    }

    std::string PaxosLayer::toString(){ return ""; }

}