# p4-traffictools

p4-traffictools is a tool designed to aid P4 developers with the process of packet generation, parsing and dissection. It automatically generates code for several traffic generation and parsing tools such that they can readily support the custom packet format(s) defined by your P4 program. p4-traffictools currently supports code generation for [Scapy](https://scapy.net), [PcapPlusPlus](https://github.com/seladb/PcapPlusPlus), [MoonGen](https://github.com/emmericp/MoonGen/) and [Lua dissector for Wireshark (Tshark)](https://wiki.wireshark.org/Lua/Dissectors).

So whether behavioral (qualitative) testing on software targets (e.g. [bmv2](https://github.com/p4lang/behavioral-model)) or production (quantitative) testing on hardware targets (e.g. [Barefoot Tofino](https://barefootnetworks.com/products/brief-tofino/)), p4-traffictools has you covered :)


## Contents
* [Getting Started](#getting-started)
* [Usage](#usage)
  * [Using the output files](#using-the-output-files)
* [Nuances](#nuances)
* [Similar tools](#similar-tools)


## Getting Started
### Dependencies
* **p4c compiler:** The input to p4-traffictools is the json file produced by the open-source p4c compiler, specifically the `p4c-bm2-ss` backend. Follow the instructions [here](https://github.com/p4lang/p4c) to install `p4c` and the `p4c-bm2-ss` backend. For the `p4c-bm2-ss` backend to compile correctly, you may need to install [behavioral model](https://github.com/p4lang/behavioral-model) first. Post installation, `p4c-bm2-ss` should be available in your _PATH_. 
* **Python interpreter:** p4-traffictools is written in Python and can work with both Python2 and Python3. Most Linux distributions come preinstalled with either Python2 or Python3.
* **Traffic Tools:** Since you are trying to install and use p4-traffictools, we assume you have the appropriate traffic generation/parsing tools for which you would be auto-generating the code. p4-traffictools currently supports code generation for [Scapy](https://scapy.net), [PcapPlusPlus](https://github.com/seladb/PcapPlusPlus), [MoonGen](https://github.com/emmericp/MoonGen/) and [Wireshark Dissector](https://wiki.wireshark.org/Lua/Dissectors).

### Installation
Simply clone this repository. No other action is required.
```
git clone https://github.com/djin31/p4-traffictools.git
```

## Usage

For usage with a P4 source file, use the top-level script _p4-traffictools.sh_ as following:
```
./p4-traffictools.sh <path to p4 source file> <specify standard {p4-14, p4-16}> [output directory path] [--scapy] [--wireshark] [--moongen] [--pcpp] [--d for debug mode]
```

For usage directly with a json file, use the top-level script _p4-traffictools.sh_ as following:
```
./p4-traffictools.sh <path to json file> [output directory path] [--scapy] [--wireshark] [--moongen] [--pcpp] [--d for debug mode]
```
* output directory path: If not specified, the default output directory is the same directory as the P4/json input file.
* target tool(s): At least one of `--scapy` `--wireshark` `--moongen` `--pcpp` needs to be specified. 

The above command will generate output files for specified target tool(s). The output files for each target tool will be placed in a subdirectory inside the _output directory_.



### Additional User Inputs
* **Standard headers:** If standard headers for common protocols such as Ethernet, IPv4, IPv6, TCP, and UDP are detected by p4-traffictools, it will prompt the user if s/he wishes to use the original header/protocol implementations provided by the tool(s) instead of generating new implementations for them. An exception for this is the code generated for the Wireshark Lua dissector (see more details in [Nuances.md](Nuances.md)).
* **Variable Length Fields:** TODO


### Using the output files
The generated output files need to be integrated with the correponding tool. See [ToolSpecificUsage.md](ToolSpecificUsage.md) for detailed steps.

## Nuances
While p4-traffictools works pretty well for most general cases, there are few tool-specific nuances and known issues. Please refer [Nuances.md](Nuances.md) for details.


## Similar tools
[p4pktgen](https://github.com/p4pktgen/p4pktgen) is closely related to p4-traffictools. But the target usecases for the two tools are completely different. p4pktgen is a tool that is focused more towards testing all possible packet header combinations, whereas p4-traffictools is a tool which provides auto-generated code which the user can plug into popular traffic generation and parsing tools.

[P4 Wireshark Dissector](https://github.com/gnikol/P4-Wireshark-Dissector) also generates a Wireshark (Tshark) Lua dissector plugin for a given P4 program. TODO
