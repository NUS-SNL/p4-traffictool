#define LOG_MODULE PacketLogModuleNc_loadLayer

#include "netcache_nc_load.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint32_t Nc_loadLayer::getLoad_1(){
        uint32_t load_1;
        nc_loadhdr* hdrdata = (nc_loadhdr*)m_Data;
        load_1 = htonl(hdrdata->load_1);
        return load_1;
    }

    void Nc_loadLayer::setLoad_1(uint32_t value){
        nc_loadhdr* hdrdata = (nc_loadhdr*)m_Data;
        hdrdata->load_1 = htonl(value);
    }
    uint32_t Nc_loadLayer::getLoad_2(){
        uint32_t load_2;
        nc_loadhdr* hdrdata = (nc_loadhdr*)m_Data;
        load_2 = htonl(hdrdata->load_2);
        return load_2;
    }

    void Nc_loadLayer::setLoad_2(uint32_t value){
        nc_loadhdr* hdrdata = (nc_loadhdr*)m_Data;
        hdrdata->load_2 = htonl(value);
    }
    uint32_t Nc_loadLayer::getLoad_3(){
        uint32_t load_3;
        nc_loadhdr* hdrdata = (nc_loadhdr*)m_Data;
        load_3 = htonl(hdrdata->load_3);
        return load_3;
    }

    void Nc_loadLayer::setLoad_3(uint32_t value){
        nc_loadhdr* hdrdata = (nc_loadhdr*)m_Data;
        hdrdata->load_3 = htonl(value);
    }
    uint32_t Nc_loadLayer::getLoad_4(){
        uint32_t load_4;
        nc_loadhdr* hdrdata = (nc_loadhdr*)m_Data;
        load_4 = htonl(hdrdata->load_4);
        return load_4;
    }

    void Nc_loadLayer::setLoad_4(uint32_t value){
        nc_loadhdr* hdrdata = (nc_loadhdr*)m_Data;
        hdrdata->load_4 = htonl(value);
    }
    void Nc_loadLayer::parseNextLayer(){
        if (m_DataLen <= sizeof(nc_loadhdr))
            return;

    }

    std::string Nc_loadLayer::toString(){ return ""; }

}