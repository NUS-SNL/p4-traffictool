#define LOG_MODULE PacketLogModuleNc_hdrLayer

#include "netchain_nc_hdr.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint8_t Nc_hdrLayer::getOp(){
        uint8_t op;
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        op = (hdrdata->op);
        return op;
    }

    void Nc_hdrLayer::setOp(uint8_t value){
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        hdrdata->op = (value);
    }
    uint8_t Nc_hdrLayer::getSc(){
        uint8_t sc;
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        sc = (hdrdata->sc);
        return sc;
    }

    void Nc_hdrLayer::setSc(uint8_t value){
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        hdrdata->sc = (value);
    }
    uint16_t Nc_hdrLayer::getSeq(){
        uint16_t seq;
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        seq = htons(hdrdata->seq);
        return seq;
    }

    void Nc_hdrLayer::setSeq(uint16_t value){
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        hdrdata->seq = htons(value);
    }
    uint64_t Nc_hdrLayer::getKey(){
        uint64_t key;
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        key = htobe64(hdrdata->key);
        return key;
    }

    void Nc_hdrLayer::setKey(uint64_t value){
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        hdrdata->key = htobe64(value);
    }
    uint64_t Nc_hdrLayer::getValue(){
        uint64_t value;
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        value = htobe64(hdrdata->value);
        return value;
    }

    void Nc_hdrLayer::setValue(uint64_t value){
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        hdrdata->value = htobe64(value);
    }
    uint16_t Nc_hdrLayer::getVgroup(){
        uint16_t vgroup;
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        vgroup = htons(hdrdata->vgroup);
        return vgroup;
    }

    void Nc_hdrLayer::setVgroup(uint16_t value){
        nc_hdrhdr* hdrdata = (nc_hdrhdr*)m_Data;
        hdrdata->vgroup = htons(value);
    }
    void Nc_hdrLayer::parseNextLayer(){
        if (m_DataLen <= sizeof(nc_hdrhdr))
            return;

    }

    std::string Nc_hdrLayer::toString(){ return ""; }

}