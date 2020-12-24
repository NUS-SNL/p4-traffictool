#define LOG_MODULE PacketLogModuleNc_value_3Layer

#include "netcache_nc_value_3.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint32_t Nc_value_3Layer::getValue_3_1(){
        uint32_t value_3_1;
        nc_value_3hdr* hdrdata = (nc_value_3hdr*)m_Data;
        value_3_1 = htonl(hdrdata->value_3_1);
        return value_3_1;
    }

    void Nc_value_3Layer::setValue_3_1(uint32_t value){
        nc_value_3hdr* hdrdata = (nc_value_3hdr*)m_Data;
        hdrdata->value_3_1 = htonl(value);
    }
    uint32_t Nc_value_3Layer::getValue_3_2(){
        uint32_t value_3_2;
        nc_value_3hdr* hdrdata = (nc_value_3hdr*)m_Data;
        value_3_2 = htonl(hdrdata->value_3_2);
        return value_3_2;
    }

    void Nc_value_3Layer::setValue_3_2(uint32_t value){
        nc_value_3hdr* hdrdata = (nc_value_3hdr*)m_Data;
        hdrdata->value_3_2 = htonl(value);
    }
    uint32_t Nc_value_3Layer::getValue_3_3(){
        uint32_t value_3_3;
        nc_value_3hdr* hdrdata = (nc_value_3hdr*)m_Data;
        value_3_3 = htonl(hdrdata->value_3_3);
        return value_3_3;
    }

    void Nc_value_3Layer::setValue_3_3(uint32_t value){
        nc_value_3hdr* hdrdata = (nc_value_3hdr*)m_Data;
        hdrdata->value_3_3 = htonl(value);
    }
    uint32_t Nc_value_3Layer::getValue_3_4(){
        uint32_t value_3_4;
        nc_value_3hdr* hdrdata = (nc_value_3hdr*)m_Data;
        value_3_4 = htonl(hdrdata->value_3_4);
        return value_3_4;
    }

    void Nc_value_3Layer::setValue_3_4(uint32_t value){
        nc_value_3hdr* hdrdata = (nc_value_3hdr*)m_Data;
        hdrdata->value_3_4 = htonl(value);
    }
    void Nc_value_3Layer::parseNextLayer(){
        if (m_DataLen <= sizeof(nc_value_3hdr))
            return;

    }

    std::string Nc_value_3Layer::toString(){ return ""; }

}