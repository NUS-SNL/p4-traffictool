#define LOG_MODULE PacketLogModuleTcpLayer

#include "TcpLayer.h"
#include "PayloadLayer.h"
#include "IpUtils.h"
#include "Logger.h"
#include <string.h>
#include <sstream>
#include <endian.h>

namespace pcpp{
	uint16_t TcpLayer::getSrcport(){
		uint16_t srcPort;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		srcPort = htons(hdrdata->srcPort);
		return srcPort;
	}

	uint16_t TcpLayer::getDstport(){
		uint16_t dstPort;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		dstPort = htons(hdrdata->dstPort);
		return dstPort;
	}

	uint32_t TcpLayer::getSeqno(){
		uint32_t seqNo;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		seqNo = htonl(hdrdata->seqNo);
		return seqNo;
	}

	uint32_t TcpLayer::getAckno(){
		uint32_t ackNo;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		ackNo = htonl(hdrdata->ackNo);
		return ackNo;
	}

	uint8_t TcpLayer::getDataoffset(){
		uint8_t dataOffset;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		dataOffset = (hdrdata->dataOffset);
		return dataOffset;
	}

	uint8_t TcpLayer::getRes(){
		uint8_t res;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		res = (hdrdata->res);
		return res;
	}

	uint8_t TcpLayer::getEcn(){
		uint8_t ecn;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		ecn = (hdrdata->ecn);
		return ecn;
	}

	uint8_t TcpLayer::getCtrl(){
		uint8_t ctrl;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		ctrl = (hdrdata->ctrl);
		return ctrl;
	}

	uint16_t TcpLayer::getWindow(){
		uint16_t window;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		window = htons(hdrdata->window);
		return window;
	}

	uint16_t TcpLayer::getChecksum(){
		uint16_t checksum;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		checksum = htons(hdrdata->checksum);
		return checksum;
	}

	uint16_t TcpLayer::getUrgentptr(){
		uint16_t urgentPtr;
		tcphdr* hdrdata = (tcphdr*)m_Data;
		urgentPtr = htons(hdrdata->urgentPtr);
		return urgentPtr;
	}

	void TcpLayer::parseNextLayer(){
		if (m_DataLen <= sizeof(tcphdr))
			return;


	std::string TcpLayer::toString(){}

