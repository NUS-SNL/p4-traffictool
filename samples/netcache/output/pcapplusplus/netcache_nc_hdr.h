//Template for addition of new protocol 'nc_hdr'

#ifndef P4_NC_HDR_LAYER
#define P4_NC_HDR_LAYER

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
    struct nc_hdrhdr{
        uint8_t      op;
        uint64_t      key;
    };

    #pragma pack(pop)
    class Nc_hdrLayer: public Layer{
        public:
        Nc_hdrLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_NC_HDR;}
        Nc_hdrLayer(){
            m_DataLen = sizeof(nc_hdrhdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_NC_HDR;
        }

         // Getters and Setters for fields
         uint8_t getOp();
         void setOp(uint8_t value);
         uint64_t getKey();
         void setKey(uint64_t value);

         inline nc_hdrhdr* getNc_hdrHeader() { return (nc_hdrhdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(nc_hdrhdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif