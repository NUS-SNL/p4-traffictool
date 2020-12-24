//Template for addition of new protocol 'hdr_meta'

#ifndef P4_HDR_META_LAYER
#define P4_HDR_META_LAYER

#include <cstring>
#include "Layer.h"
#include "uint24_t.h"
#include "uint40_t.h"
#include "uint48_t.h"
#if defined(WIN32) || defined(WINx64)
#include <winsock2.h>
#elif LINUX
#include <in.h>
#endif

namespace pcpp{
    #pragma pack(push,1)
    struct hdr_metahdr{
        uint48_t      mac_dstAddr;
        uint48_t      mac_srcAddr;
        uint32_t      ip_srcAddr;
        uint32_t      ip_dstAddr;
        uint8_t      ip_protocol;
    };

    #pragma pack(pop)
    class Hdr_metaLayer: public Layer{
        public:
        Hdr_metaLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_HDR_META;}
        Hdr_metaLayer(){
            m_DataLen = sizeof(hdr_metahdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_HDR_META;
        }

         // Getters and Setters for fields
         uint64_t getMac_dstaddr();
         void setMac_dstaddr(uint64_t value);
         uint64_t getMac_srcaddr();
         void setMac_srcaddr(uint64_t value);
         uint32_t getIp_srcaddr();
         void setIp_srcaddr(uint32_t value);
         uint32_t getIp_dstaddr();
         void setIp_dstaddr(uint32_t value);
         uint8_t getIp_protocol();
         void setIp_protocol(uint8_t value);

         inline hdr_metahdr* getHdr_metaHeader() { return (hdr_metahdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(hdr_metahdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif