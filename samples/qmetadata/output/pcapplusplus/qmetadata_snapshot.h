//Template for addition of new protocol 'snapshot'

#ifndef P4_SNAPSHOT_LAYER
#define P4_SNAPSHOT_LAYER

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
    struct snapshothdr{
        uint16_t      ingress_global_tstamp_hi_16;
        uint32_t      ingress_global_tstamp_lo_32;
        uint32_t      egress_global_tstamp_lo_32;
        uint32_t      enq_qdepth;
        uint32_t      deq_qdepth;
        uint64_t      orig_egress_global_tstamp;
        uint64_t      new_egress_global_tstamp;
        uint32_t      new_enq_tstamp;
    };

    #pragma pack(pop)
    class SnapshotLayer: public Layer{
        public:
        SnapshotLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_SNAPSHOT;}
        SnapshotLayer(){
            m_DataLen = sizeof(snapshothdr);
            m_Data = new uint8_t[m_DataLen];
            memset(m_Data, 0, m_DataLen);
            m_Protocol = P4_SNAPSHOT;
        }

         // Getters and Setters for fields
         uint16_t getIngress_global_tstamp_hi_16();
         void setIngress_global_tstamp_hi_16(uint16_t value);
         uint32_t getIngress_global_tstamp_lo_32();
         void setIngress_global_tstamp_lo_32(uint32_t value);
         uint32_t getEgress_global_tstamp_lo_32();
         void setEgress_global_tstamp_lo_32(uint32_t value);
         uint32_t getEnq_qdepth();
         void setEnq_qdepth(uint32_t value);
         uint32_t getDeq_qdepth();
         void setDeq_qdepth(uint32_t value);
         uint64_t getOrig_egress_global_tstamp();
         void setOrig_egress_global_tstamp(uint64_t value);
         uint64_t getNew_egress_global_tstamp();
         void setNew_egress_global_tstamp(uint64_t value);
         uint32_t getNew_enq_tstamp();
         void setNew_enq_tstamp(uint32_t value);

         inline snapshothdr* getSnapshotHeader() { return (snapshothdr*)m_Data; }

         void parseNextLayer();

         inline size_t getHeaderLen() { return sizeof(snapshothdr); }

         void computeCalculateFields() {}

         std::string toString();

         OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }

    };
}
#endif