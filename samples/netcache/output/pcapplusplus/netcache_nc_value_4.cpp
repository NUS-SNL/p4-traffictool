#define LOG_MODULE PacketLogModuleNc_value_4Layer

#include "netcache_nc_value_4.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint32_t Nc_value_4Layer::getValue_4_1(){
        uint32_t value_4_1;
        nc_value_4hdr* hdrdata = (nc_value_4hdr*)m_Data;
        value_4_1 = htonl(hdrdata->value_4_1);
        return value_4_1;
    }

    void Nc_value_4Layer::setValue_4_1(uint32_t value){
        nc_value_4hdr* hdrdata = (nc_value_4hdr*)m_Data;
        hdrdata->value_4_1 = htonl(value);
    }
    uint32_t Nc_value_4Layer::getValue_4_2(){
        uint32_t value_4_2;
        nc_value_4hdr* hdrdata = (nc_value_4hdr*)m_Data;
        value_4_2 = htonl(hdrdata->value_4_2);
        return value_4_2;
    }

    void Nc_value_4Layer::setValue_4_2(uint32_t value){
        nc_value_4hdr* hdrdata = (nc_value_4hdr*)m_Data;
        hdrdata->value_4_2 = htonl(value);
    }
    uint32_t Nc_value_4Layer::getValue_4_3(){
        uint32_t value_4_3;
        nc_value_4hdr* hdrdata = (nc_value_4hdr*)m_Data;
        value_4_3 = htonl(hdrdata->value_4_3);
        return value_4_3;
    }

    void Nc_value_4Layer::setValue_4_3(uint32_t value){
        nc_value_4hdr* hdrdata = (nc_value_4hdr*)m_Data;
        hdrdata->value_4_3 = htonl(value);
    }
    uint32_t Nc_value_4Layer::getValue_4_4(){
        uint32_t value_4_4;
        nc_value_4hdr* hdrdata = (nc_value_4hdr*)m_Data;
        value_4_4 = htonl(hdrdata->value_4_4);
        return value_4_4;
    }

    void Nc_value_4Layer::setValue_4_4(uint32_t value){
        nc_value_4hdr* hdrdata = (nc_value_4hdr*)m_Data;
        hdrdata->value_4_4 = htonl(value);
    }
    void Nc_value_4Layer::parseNextLayer(){
        if (m_DataLen <= sizeof(nc_value_4hdr))
            return;

    }

    std::string Nc_value_4Layer::toString(){ return ""; }

}