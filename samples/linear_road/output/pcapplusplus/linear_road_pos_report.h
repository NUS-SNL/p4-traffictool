//Template for addition of new protocol 'pos_report'

#ifndef P4_POS_REPORT_LAYER
#define P4_POS_REPORT_LAYER

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
    struct pos_reporthdr{
        uint16_t      time;
        uint32_t      vid;
        uint8_t      spd;
        uint8_t      xway;
        uint8_t      lane;
        uint8_t      dir;
        uint8_t      seg;
    };

    #pragma pack(pop)
    class Pos_reportLayer: public Layer{
        public:
        Pos_reportLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_POS_REPORT;}
        Pos_reportLayer(){
            m_DataLen = sizeof(pos_reporthdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_POS_REPORT;
        }

         // Getters and Setters for fields
         uint16_t getTime();
         void setTime(uint16_t value);
         uint32_t getVid();
         void setVid(uint32_t value);
         uint8_t getSpd();
         void setSpd(uint8_t value);
         uint8_t getXway();
         void setXway(uint8_t value);
         uint8_t getLane();
         void setLane(uint8_t value);
         uint8_t getDir();
         void setDir(uint8_t value);
         uint8_t getSeg();
         void setSeg(uint8_t value);

         inline pos_reporthdr* getPos_reportHeader() { return (pos_reporthdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(pos_reporthdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif