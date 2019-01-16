#define LOG_MODULE PacketLogModuleLr_msg_typeLayer

#include "linear_road_lr_msg_type.h"
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

		lr_msg_typehdr* hdrdata = getLr_msg_typeHeader();
		uint8_t msg_type = (hdrdata->msg_type);
		if (msg_type == 0x00)
			m_NextLayer = new Pos_reportLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
		else if (msg_type == 0x02)
			m_NextLayer = new Accnt_bal_reqLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
		else if (msg_type == 0x0a)
			m_NextLayer = new Toll_notificationLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
		else if (msg_type == 0x0b)
			m_NextLayer = new Accident_alertLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
		else if (msg_type == 0x0c)
			m_NextLayer = new Accnt_balLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
		else if (msg_type == 0x03)
			m_NextLayer = new Expenditure_reqLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
		else if (msg_type == 0x0d)
			m_NextLayer = new Expenditure_reportLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
		else if (msg_type == 0x04)
			m_NextLayer = new Travel_estimate_reqLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
		else if (msg_type == 0x0e)
			m_NextLayer = new Travel_estimateLayer(m_Data+sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
		else
			m_NextLayer = new PayloadLayer(m_Data + sizeof(lr_msg_typehdr), m_DataLen - sizeof(lr_msg_typehdr), this, m_Packet);
	}

	std::string Lr_msg_typeLayer::toString(){ return ""; }

}