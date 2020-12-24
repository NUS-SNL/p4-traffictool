//Template for addition of new protocol 'travel_estimate_req'

#ifndef P4_TRAVEL_ESTIMATE_REQ_LAYER
#define P4_TRAVEL_ESTIMATE_REQ_LAYER

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
    struct travel_estimate_reqhdr{
        uint16_t      time;
        uint32_t      qid;
        uint8_t      xway;
        uint8_t      seg_init;
        uint8_t      seg_end;
        uint8_t      dow;
        uint8_t      tod;
    };

    #pragma pack(pop)
    class Travel_estimate_reqLayer: public Layer{
        public:
        Travel_estimate_reqLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_TRAVEL_ESTIMATE_REQ;}
        Travel_estimate_reqLayer(){
            m_DataLen = sizeof(travel_estimate_reqhdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_TRAVEL_ESTIMATE_REQ;
        }

         // Getters and Setters for fields
         uint16_t getTime();
         void setTime(uint16_t value);
         uint32_t getQid();
         void setQid(uint32_t value);
         uint8_t getXway();
         void setXway(uint8_t value);
         uint8_t getSeg_init();
         void setSeg_init(uint8_t value);
         uint8_t getSeg_end();
         void setSeg_end(uint8_t value);
         uint8_t getDow();
         void setDow(uint8_t value);
         uint8_t getTod();
         void setTod(uint8_t value);

         inline travel_estimate_reqhdr* getTravel_estimate_reqHeader() { return (travel_estimate_reqhdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(travel_estimate_reqhdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif