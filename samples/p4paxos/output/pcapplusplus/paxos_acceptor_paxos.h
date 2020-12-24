//Template for addition of new protocol 'paxos'

#ifndef P4_PAXOS_LAYER
#define P4_PAXOS_LAYER

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
    struct paxoshdr{
        uint8_t      msgtype;
        uint16_t      instance;
        uint8_t      round;
        uint8_t      vround;
        uint64_t      acceptor;
        -- fill blank here 512      value;
    };

    #pragma pack(pop)
    class PaxosLayer: public Layer{
        public:
        PaxosLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_PAXOS;}
        PaxosLayer(){
            m_DataLen = sizeof(paxoshdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_PAXOS;
        }

         // Getters and Setters for fields
         uint8_t getMsgtype();
         void setMsgtype(uint8_t value);
         uint16_t getInstance();
         void setInstance(uint16_t value);
         uint8_t getRound();
         void setRound(uint8_t value);
         uint8_t getVround();
         void setVround(uint8_t value);
         uint64_t getAcceptor();
         void setAcceptor(uint64_t value);
         None getValue();
         void setValue(None value);

         inline paxoshdr* getPaxosHeader() { return (paxoshdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(paxoshdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif