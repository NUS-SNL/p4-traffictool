# p4-traffictools

p4-traffictools is a tool designed to aid P4-programming by easing the process of testing the code using packet generation, parsing and dissection tools. p4-traffictools supports code generation for Scapy, PCapPlusPlus, MoonGen and Lua dissector for Wireshark.

To get better undersanding of the purpose of tool, see the sample input P4 programs and corresponding outputs in the samples directory.

## Contents
* [Scapy as backend](#scapy-as-backend)
* [PCapPlusPlus as backend](#pcapplusplus-as-backend)
* [MoonGen as backend](#moongen-as-backend)
* [Lua with Wireshark as backend](#lua-with-wireshark-as-backend)
* [Similar tools](#similar-tools)
* [Requirements](#requirements)
* [Usage](#usage)

## Scapy as backend

[Scapy](https://scapy.net/) is a powerful Python-based interactive packet manipulation program and library. The code generated for Scapy can be used for packet generation, dumping packets to pcap file or simply sending them on wire, as well as parsing and dissecting packets.

### What the generated code provides
* Creates Scapy classes for the headers defined in the p4 program
* Provides functionality for using _common standard headers_*
* Detects variable length fields and points user to fill them suitably in class definition
* Lastly, it produces a list of all possible packet combinations possible using the defined headers


### What it doesn't
* Post build fields like length and checksums need to be defined by the user himself/herself in the post build method
* All fields are treated as bitfields, user can modify them according to ones need to support types such as int, short or any other suitable fields

Usage details for the tool with Scapy as backend can be found [here](UsageWithBackend.md#using-scapy-code).

## PCapPlusPlus as backend
[PcapPlusPlus](http://seladb.github.io/PcapPlusPlus-Doc) is a multiplatform C++ network sniffing and packet parsing and crafting framework. It provides a very fast and efficient method for crafting and parsing network packets.

### What the generated code provides
* Creates files correponding to each protocol defining the header struct, and getter and setter functions.
* Provides functionality for using _common standard headers_*
* Detects variable length fields and prompts user to mention the size required for the current testbench

### What it doesn't
* Post build fields like length and checksums need to be calculated in the setter function by the user
* Field lengths which are not amongst {8, 16, 32, 64} shall be promoted to the next higher power of 2. If the user needs a field to be strictly of a particular size other than these then a proper struct needs to be defined and corresponding _ntoh_ and _hton_ functions need to be defined
* If using default headers then user need to modify the parseNextLayer of the default header layer to include next layers.
* User needs to modify the ProtocolType.h file to include the new layers

Usage details for the tool with PcapPlusPlus as backend can be found [here](UsageWithBackend.md#using-pcapplusplus-code).

## MoonGen as backend
[MoonGen](https://github.com/emmericp/MoonGen) is a scriptable high-speed packet generator built on libmoon. The whole load generator is controlled by a Lua script: all packets that are sent are crafted by a user-provided script. 

### What the generated code provides
* Creates files correponding to each protocol defining the header struct, and getter and setter functions.
* Provides functionality for using _common standard headers_*
* Detects variable length fields and prompts user to mention the size required for the current testbench

### What it doesn't
* Post build fields like length and checksums need to be calculated in the setter function by the user
* Field lengths which are not amongst {8, 16, 24, 32, 40, 48, 64} shall be promoted to the next higher power of 2. If the user needs a field to be strictly of a particular size other than these then a proper struct needs to be defined and corresponding _ntoh_ and _hton_ functions need to be defined
* If using default headers then user need to modify the resolveNextHeader of the default header layer to include next layers.

Usage details for the tool with MoonGen as backend can be found [here](UsageWithBackend.md#using-moongen-code).

## Lua with Wireshark as backend
### What the generated code provides
* Creates files correponding to each protocol defining the header struct
* Detects variable length fields and prompts user to mention the size required for the current testbench
* Generates an init file specifying the order in which to load the scripts

### What it doesn't
* For parsing the packet correctly, user may need to disable the standard parsers of Wireshark

Usage details for the tool with Wireshark as backend can be found [here](UsageWithBackend.md#using-lua-dissectors-for-wireshark-or-tshark).


## Similar tools
p4-traffictools and [p4pktgen](https://github.com/p4pktgen/p4pktgen) are closely related in their models however their applications are completely different.

p4pktgen is a tool that is focused more towards testing of all possible packet header combinations
whereas p4-traffictools is a tool which provides an interface to the user using which one can generate and parse network traffic based on the headers defined in the P4 program

## Requirements
The code compiles the p4 code to generate the json output which it uses to generate codes for different backends.
For compiling the p4 code user needs the [p4c](https://github.com/p4lang/p4c) compiler, specifically the _p4c-bm2-ss_ backend.

The scripts to generate code can work both with python2 as well as python3.

Lastly, to make use of the generated codes user needs the suitable backends.

## Usage

To run the toplevel script:
```
./p4-pktcodegen.sh <path to p4 source> <specify standard {p4-14, p4-16}> <specify destination directory path> [-scapy] [-wireshark] [-moongen] [-pcpp] [--d for debug mode]
```

To run the individual scripts to backend code generation:
```
python <path to the appropriate script> <path to json output of p4 program> <path to destination directory> [-d for debug mode]
```

Scapy backend &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp; &nbsp; : [GenTrafficScapy.py](src/GenTrafficScapy.py) <br>
PcapPlusPlus backend &nbsp;: [DissectTrafficPcap.py](src/DissectTrafficPcap.py) <br>
MoonGen backend &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; : [GenTrafficMoonGen.py](src/GenTrafficMoonGen.py) <br>
Lua Wireshark backend : [DissectTrafficLua.py](src/DissectTrafficLua.py) <br>

Usage of the generated code for different backends can be found in [UsageWithBackend.md](UsageWithBackend.md)

\* common standard headers include Ethernet, IPv4, IPv6, TCP, UDP. These are detected by the tool only if their name in P4 code is amongst {ethernet, ipv4, ipv6, tcp, udp}.
