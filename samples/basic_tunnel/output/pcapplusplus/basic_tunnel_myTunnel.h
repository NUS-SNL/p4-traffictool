//Template for addition of new protocol 'myTunnel'

#ifndef P4_MYTUNNEL_LAYER
#define P4_MYTUNNEL_LAYER

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
    struct mytunnelhdr{
        uint16_t      proto_id;
        uint16_t      dst_id;
    };

    #pragma pack(pop)
    class MytunnelLayer: public Layer{
        public:
        MytunnelLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_MYTUNNEL;}
        MytunnelLayer(){
            m_DataLen = sizeof(mytunnelhdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_MYTUNNEL;
        }

         // Getters and Setters for fields
         uint16_t getProto_id();
         void setProto_id(uint16_t value);
         uint16_t getDst_id();
         void setDst_id(uint16_t value);

         inline mytunnelhdr* getMytunnelHeader() { return (mytunnelhdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(mytunnelhdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif