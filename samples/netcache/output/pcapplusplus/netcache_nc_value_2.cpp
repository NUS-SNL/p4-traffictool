#define LOG_MODULE PacketLogModuleNc_value_2Layer

#include "netcache_nc_value_2.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint32_t Nc_value_2Layer::getValue_2_1(){
        uint32_t value_2_1;
        nc_value_2hdr* hdrdata = (nc_value_2hdr*)m_Data;
        value_2_1 = htonl(hdrdata->value_2_1);
        return value_2_1;
    }

    void Nc_value_2Layer::setValue_2_1(uint32_t value){
        nc_value_2hdr* hdrdata = (nc_value_2hdr*)m_Data;
        hdrdata->value_2_1 = htonl(value);
    }
    uint32_t Nc_value_2Layer::getValue_2_2(){
        uint32_t value_2_2;
        nc_value_2hdr* hdrdata = (nc_value_2hdr*)m_Data;
        value_2_2 = htonl(hdrdata->value_2_2);
        return value_2_2;
    }

    void Nc_value_2Layer::setValue_2_2(uint32_t value){
        nc_value_2hdr* hdrdata = (nc_value_2hdr*)m_Data;
        hdrdata->value_2_2 = htonl(value);
    }
    uint32_t Nc_value_2Layer::getValue_2_3(){
        uint32_t value_2_3;
        nc_value_2hdr* hdrdata = (nc_value_2hdr*)m_Data;
        value_2_3 = htonl(hdrdata->value_2_3);
        return value_2_3;
    }

    void Nc_value_2Layer::setValue_2_3(uint32_t value){
        nc_value_2hdr* hdrdata = (nc_value_2hdr*)m_Data;
        hdrdata->value_2_3 = htonl(value);
    }
    uint32_t Nc_value_2Layer::getValue_2_4(){
        uint32_t value_2_4;
        nc_value_2hdr* hdrdata = (nc_value_2hdr*)m_Data;
        value_2_4 = htonl(hdrdata->value_2_4);
        return value_2_4;
    }

    void Nc_value_2Layer::setValue_2_4(uint32_t value){
        nc_value_2hdr* hdrdata = (nc_value_2hdr*)m_Data;
        hdrdata->value_2_4 = htonl(value);
    }
    void Nc_value_2Layer::parseNextLayer(){
        if (m_DataLen <= sizeof(nc_value_2hdr))
            return;

    }

    std::string Nc_value_2Layer::toString(){ return ""; }

}