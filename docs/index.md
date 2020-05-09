---
title: P4TrafficTool
layout: default
filename: index
--- 

# P4TrafficTool

The flexibility provided by P4 and programmable network hardware, has enabled develepoment of new protocols and applications that invariably introduce new protocol headers. 

<br>

<p align="center">
	<img src="/p4-traffictool/images/problem-new.png" style="width:80%">
</p>

<br>

**P4TrafficTool** is a tool designed to aid P4 developers with the process of packet generation, parsing and dissection. It automatically generates code for several traffic generation and parsing tools such that they can readily support the custom packet format(s) defined by your P4 program. p4-traffictool currently supports code generation for [Scapy](https://scapy.net), [PcapPlusPlus](https://github.com/seladb/PcapPlusPlus), [MoonGen](https://github.com/emmericp/MoonGen/) and [Lua dissector for Wireshark (Tshark)](https://wiki.wireshark.org/Lua/Dissectors).

So whether behavioral (qualitative) testing on software targets (e.g. [bmv2](https://github.com/p4lang/behavioral-model)) or production (quantitative) testing on hardware targets (e.g. [Barefoot Tofino](https://barefootnetworks.com/products/brief-tofino/)), p4-traffictool has you covered.


