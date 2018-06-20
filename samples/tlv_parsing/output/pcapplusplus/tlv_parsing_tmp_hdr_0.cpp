#define LOG_MODULE PacketLogModuleTmp_hdr_0Layer

#include "Tmp_hdr_0Layer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	-- fill blank here * Tmp_hdr_0Layer::getData(){
		-- fill blank here * data;
		tmp_hdr_0hdr* hdrdata = (tmp_hdr_0hdr*)m_Data;
		data = -- fill blank here(hdrdata->data);
		return data;
	}

	void Tmp_hdr_0Layer::parseNextLayer(){
		if (m_DataLen <= sizeof(tmp_hdr_0hdr))
			return;


	std::string Tmp_hdr_0Layer::toString(){}

