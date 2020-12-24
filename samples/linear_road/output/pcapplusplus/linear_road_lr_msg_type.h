//Template for addition of new protocol 'lr_msg_type'

#ifndef P4_LR_MSG_TYPE_LAYER
#define P4_LR_MSG_TYPE_LAYER

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
    struct lr_msg_typehdr{
        uint8_t      msg_type;
    };

    #pragma pack(pop)
    class Lr_msg_typeLayer: public Layer{
        public:
        Lr_msg_typeLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_LR_MSG_TYPE;}
        Lr_msg_typeLayer(){
            m_DataLen = sizeof(lr_msg_typehdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_LR_MSG_TYPE;
        }

         // Getters and Setters for fields
         uint8_t getMsg_type();
         void setMsg_type(uint8_t value);

         inline lr_msg_typehdr* getLr_msg_typeHeader() { return (lr_msg_typehdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(lr_msg_typehdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif