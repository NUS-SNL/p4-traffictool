//Template for addition of new protocol 'accnt_bal_req'

#ifndef P4_ACCNT_BAL_REQ_LAYER
#define P4_ACCNT_BAL_REQ_LAYER

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
    struct accnt_bal_reqhdr{
        uint16_t      time;
        uint32_t      vid;
        uint32_t      qid;
    };

    #pragma pack(pop)
    class Accnt_bal_reqLayer: public Layer{
        public:
        Accnt_bal_reqLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_ACCNT_BAL_REQ;}
        Accnt_bal_reqLayer(){
            m_DataLen = sizeof(accnt_bal_reqhdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_ACCNT_BAL_REQ;
        }

         // Getters and Setters for fields
         uint16_t getTime();
         void setTime(uint16_t value);
         uint32_t getVid();
         void setVid(uint32_t value);
         uint32_t getQid();
         void setQid(uint32_t value);

         inline accnt_bal_reqhdr* getAccnt_bal_reqHeader() { return (accnt_bal_reqhdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(accnt_bal_reqhdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif