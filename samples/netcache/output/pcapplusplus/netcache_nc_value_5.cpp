#define LOG_MODULE PacketLogModuleNc_value_5Layer

#include "netcache_nc_value_5.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint32_t Nc_value_5Layer::getValue_5_1(){
        uint32_t value_5_1;
        nc_value_5hdr* hdrdata = (nc_value_5hdr*)m_Data;
        value_5_1 = htonl(hdrdata->value_5_1);
        return value_5_1;
    }

    void Nc_value_5Layer::setValue_5_1(uint32_t value){
        nc_value_5hdr* hdrdata = (nc_value_5hdr*)m_Data;
        hdrdata->value_5_1 = htonl(value);
    }
    uint32_t Nc_value_5Layer::getValue_5_2(){
        uint32_t value_5_2;
        nc_value_5hdr* hdrdata = (nc_value_5hdr*)m_Data;
        value_5_2 = htonl(hdrdata->value_5_2);
        return value_5_2;
    }

    void Nc_value_5Layer::setValue_5_2(uint32_t value){
        nc_value_5hdr* hdrdata = (nc_value_5hdr*)m_Data;
        hdrdata->value_5_2 = htonl(value);
    }
    uint32_t Nc_value_5Layer::getValue_5_3(){
        uint32_t value_5_3;
        nc_value_5hdr* hdrdata = (nc_value_5hdr*)m_Data;
        value_5_3 = htonl(hdrdata->value_5_3);
        return value_5_3;
    }

    void Nc_value_5Layer::setValue_5_3(uint32_t value){
        nc_value_5hdr* hdrdata = (nc_value_5hdr*)m_Data;
        hdrdata->value_5_3 = htonl(value);
    }
    uint32_t Nc_value_5Layer::getValue_5_4(){
        uint32_t value_5_4;
        nc_value_5hdr* hdrdata = (nc_value_5hdr*)m_Data;
        value_5_4 = htonl(hdrdata->value_5_4);
        return value_5_4;
    }

    void Nc_value_5Layer::setValue_5_4(uint32_t value){
        nc_value_5hdr* hdrdata = (nc_value_5hdr*)m_Data;
        hdrdata->value_5_4 = htonl(value);
    }
    void Nc_value_5Layer::parseNextLayer(){
        if (m_DataLen <= sizeof(nc_value_5hdr))
            return;

    }

    std::string Nc_value_5Layer::toString(){ return ""; }

}