#define LOG_MODULE PacketLogModuleLr_msg_typeLayer

#include "linear_road_lr_msg_type.h"
#include "linear_road_pos_report.h"
#include "linear_road_accnt_bal_req.h"
#include "linear_road_toll_notification.h"
#include "linear_road_accident_alert.h"
#include "linear_road_accnt_bal.h"
#include "linear_road_expenditure_req.h"
#include "linear_road_expenditure_report.h"
#include "linear_road_travel_estimate_req.h"
#include "linear_road_travel_estimate.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
    uint8_t Lr_msg_typeLayer::getMsg_type(){
        uint8_t msg_type;
        lr_msg_typehdr* hdrdata = (lr_msg_typehdr*)m_Data;
        msg_type = (hdrdata->msg_type);
        return msg_type;
    }

    void Lr_msg_typeLayer::setMsg_type(uint8_t value){
        lr_msg_typehdr* hdrdata = (lr_msg_typehdr*)m_Data;
        hdrdata->msg_type = (value);
    }
    void Lr_msg_typeLayer::parseNextLayer(){
        if (m_DataLen <= sizeof(lr_msg_typehdr))
            return;

        uint8_t msg_type = Lr_msg_typeLayer::getMsg_type();
        if (msg_type == 0x00)
        if (msg_type == 0x02)
        if (msg_type == 0x0a)
        if (msg_type == 0x0b)
        if (msg_type == 0x0c)
        if (msg_type == 0x03)
        if (msg_type == 0x0d)
        if (msg_type == 0x04)
            m_NextLayer = new Travel_estimate_reqLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
        else if (msg_type == 0x0e)
            m_NextLayer = new Travel_estimateLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
        else
            m_NextLayer = new PayloadLayer(m_Data + sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
    }

    std::string Lr_msg_typeLayer::toString(){ return ""; }

}