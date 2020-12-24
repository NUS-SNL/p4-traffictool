//Template for addition of new protocol 'accident_alert'

#ifndef P4_ACCIDENT_ALERT_LAYER
#define P4_ACCIDENT_ALERT_LAYER

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
    struct accident_alerthdr{
        uint16_t      time;
        uint32_t      vid;
        uint16_t      emit;
        uint8_t      seg;
    };

    #pragma pack(pop)
    class Accident_alertLayer: public Layer{
        public:
        Accident_alertLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_ACCIDENT_ALERT;}
        Accident_alertLayer(){
            m_DataLen = sizeof(accident_alerthdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_ACCIDENT_ALERT;
        }

         // Getters and Setters for fields
         uint16_t getTime();
         void setTime(uint16_t value);
         uint32_t getVid();
         void setVid(uint32_t value);
         uint16_t getEmit();
         void setEmit(uint16_t value);
         uint8_t getSeg();
         void setSeg(uint8_t value);

         inline accident_alerthdr* getAccident_alertHeader() { return (accident_alerthdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(accident_alerthdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif