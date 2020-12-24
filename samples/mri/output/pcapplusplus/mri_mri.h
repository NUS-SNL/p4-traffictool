//Template for addition of new protocol 'mri'

#ifndef P4_MRI_LAYER
#define P4_MRI_LAYER

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
    struct mrihdr{
        uint16_t      count;
    };

    #pragma pack(pop)
    class MriLayer: public Layer{
        public:
        MriLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_MRI;}
        MriLayer(){
            m_DataLen = sizeof(mrihdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_MRI;
        }

         // Getters and Setters for fields
         uint16_t getCount();
         void setCount(uint16_t value);

         inline mrihdr* getMriHeader() { return (mrihdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(mrihdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif