//Template for addition of new protocol 'expenditure_report'

#ifndef P4_EXPENDITURE_REPORT_LAYER
#define P4_EXPENDITURE_REPORT_LAYER

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
    struct expenditure_reporthdr{
        uint16_t      time;
        uint16_t      emit;
        uint32_t      qid;
        uint16_t      bal;
    };

    #pragma pack(pop)
    class Expenditure_reportLayer: public Layer{
        public:
        Expenditure_reportLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_EXPENDITURE_REPORT;}
        Expenditure_reportLayer(){
            m_DataLen = sizeof(expenditure_reporthdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_EXPENDITURE_REPORT;
        }

         // Getters and Setters for fields
         uint16_t getTime();
         void setTime(uint16_t value);
         uint16_t getEmit();
         void setEmit(uint16_t value);
         uint32_t getQid();
         void setQid(uint32_t value);
         uint16_t getBal();
         void setBal(uint16_t value);

         inline expenditure_reporthdr* getExpenditure_reportHeader() { return (expenditure_reporthdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(expenditure_reporthdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif