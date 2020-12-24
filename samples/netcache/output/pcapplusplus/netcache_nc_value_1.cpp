#define LOG_MODULE PacketLogModuleNc_value_1Layer

#include "netcache_nc_value_1.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint32_t Nc_value_1Layer::getValue_1_1(){
        uint32_t value_1_1;
        nc_value_1hdr* hdrdata = (nc_value_1hdr*)m_Data;
        value_1_1 = htonl(hdrdata->value_1_1);
        return value_1_1;
    }

    void Nc_value_1Layer::setValue_1_1(uint32_t value){
        nc_value_1hdr* hdrdata = (nc_value_1hdr*)m_Data;
        hdrdata->value_1_1 = htonl(value);
    }
    uint32_t Nc_value_1Layer::getValue_1_2(){
        uint32_t value_1_2;
        nc_value_1hdr* hdrdata = (nc_value_1hdr*)m_Data;
        value_1_2 = htonl(hdrdata->value_1_2);
        return value_1_2;
    }

    void Nc_value_1Layer::setValue_1_2(uint32_t value){
        nc_value_1hdr* hdrdata = (nc_value_1hdr*)m_Data;
        hdrdata->value_1_2 = htonl(value);
    }
    uint32_t Nc_value_1Layer::getValue_1_3(){
        uint32_t value_1_3;
        nc_value_1hdr* hdrdata = (nc_value_1hdr*)m_Data;
        value_1_3 = htonl(hdrdata->value_1_3);
        return value_1_3;
    }

    void Nc_value_1Layer::setValue_1_3(uint32_t value){
        nc_value_1hdr* hdrdata = (nc_value_1hdr*)m_Data;
        hdrdata->value_1_3 = htonl(value);
    }
    uint32_t Nc_value_1Layer::getValue_1_4(){
        uint32_t value_1_4;
        nc_value_1hdr* hdrdata = (nc_value_1hdr*)m_Data;
        value_1_4 = htonl(hdrdata->value_1_4);
        return value_1_4;
    }

    void Nc_value_1Layer::setValue_1_4(uint32_t value){
        nc_value_1hdr* hdrdata = (nc_value_1hdr*)m_Data;
        hdrdata->value_1_4 = htonl(value);
    }
    void Nc_value_1Layer::parseNextLayer(){
        if (m_DataLen <= sizeof(nc_value_1hdr))
            return;

    }

    std::string Nc_value_1Layer::toString(){ return ""; }

}