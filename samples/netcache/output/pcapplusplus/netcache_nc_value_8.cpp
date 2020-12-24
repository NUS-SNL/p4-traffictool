#define LOG_MODULE PacketLogModuleNc_value_8Layer

#include "netcache_nc_value_8.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint32_t Nc_value_8Layer::getValue_8_1(){
        uint32_t value_8_1;
        nc_value_8hdr* hdrdata = (nc_value_8hdr*)m_Data;
        value_8_1 = htonl(hdrdata->value_8_1);
        return value_8_1;
    }

    void Nc_value_8Layer::setValue_8_1(uint32_t value){
        nc_value_8hdr* hdrdata = (nc_value_8hdr*)m_Data;
        hdrdata->value_8_1 = htonl(value);
    }
    uint32_t Nc_value_8Layer::getValue_8_2(){
        uint32_t value_8_2;
        nc_value_8hdr* hdrdata = (nc_value_8hdr*)m_Data;
        value_8_2 = htonl(hdrdata->value_8_2);
        return value_8_2;
    }

    void Nc_value_8Layer::setValue_8_2(uint32_t value){
        nc_value_8hdr* hdrdata = (nc_value_8hdr*)m_Data;
        hdrdata->value_8_2 = htonl(value);
    }
    uint32_t Nc_value_8Layer::getValue_8_3(){
        uint32_t value_8_3;
        nc_value_8hdr* hdrdata = (nc_value_8hdr*)m_Data;
        value_8_3 = htonl(hdrdata->value_8_3);
        return value_8_3;
    }

    void Nc_value_8Layer::setValue_8_3(uint32_t value){
        nc_value_8hdr* hdrdata = (nc_value_8hdr*)m_Data;
        hdrdata->value_8_3 = htonl(value);
    }
    uint32_t Nc_value_8Layer::getValue_8_4(){
        uint32_t value_8_4;
        nc_value_8hdr* hdrdata = (nc_value_8hdr*)m_Data;
        value_8_4 = htonl(hdrdata->value_8_4);
        return value_8_4;
    }

    void Nc_value_8Layer::setValue_8_4(uint32_t value){
        nc_value_8hdr* hdrdata = (nc_value_8hdr*)m_Data;
        hdrdata->value_8_4 = htonl(value);
    }
    void Nc_value_8Layer::parseNextLayer(){
        if (m_DataLen <= sizeof(nc_value_8hdr))
            return;

    }

    std::string Nc_value_8Layer::toString(){ return ""; }

}