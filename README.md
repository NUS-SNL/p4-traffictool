---
title: P4TrafficTool
layout: default
filename: readme
--- 

# P4TrafficTool
P4TrafficTool is a tool designed to aid P4 developers with the process of packet generation, parsing and dissection. It automatically generates code for several traffic generation and parsing tools such that they can readily support the custom packet format(s) defined by your P4 program. p4-traffictool currently supports code generation for [Scapy](https://scapy.net), [PcapPlusPlus](https://github.com/seladb/PcapPlusPlus), [MoonGen](https://github.com/emmericp/MoonGen/) and [Lua dissector for Wireshark (Tshark)](https://wiki.wireshark.org/Lua/Dissectors).

So whether behavioral (qualitative) testing on software targets (e.g. [bmv2](https://github.com/p4lang/behavioral-model)) or production (quantitative) testing on hardware targets (e.g. [Barefoot Tofino](https://barefootnetworks.com/products/brief-tofino/)), p4-traffictool has you covered :)

## Getting Started
### Dependencies
* **p4c compiler:** The input to p4-traffictool is the json file produced by the open-source [p4c](https://github.com/p4lang/p4c) compiler, specifically the `p4c-bm2-ss` backend. You can use the scripts [here](https://github.com/jafingerhut/p4-guide) to install `p4c` and the `p4c-bm2-ss` backend. For the `p4c-bm2-ss` backend to compile correctly, you may need to install [behavioral model](https://github.com/p4lang/behavioral-model) first. Post installation, `p4c-bm2-ss` should be available in your _PATH_. 
* **Python interpreter:** p4-traffictool is written in Python and can work with both Python2 and Python3. Most Linux distributions come preinstalled with either Python2 or Python3. Required python packages: `json`, `sys`, `os`, `re` and `tabulate`. The first four are included in the standard python installation, you can install `tabulate` with `pip install tabulate`.
* **Traffic Tools:** Since you are trying to install and use p4-traffictool, we assume you have the appropriate traffic generation/parsing tools for which you would be auto-generating the code. p4-traffictool currently supports code generation for [Scapy](https://scapy.net), [PcapPlusPlus](https://github.com/seladb/PcapPlusPlus), [MoonGen](https://github.com/emmericp/MoonGen/) and [Wireshark Dissector](https://wiki.wireshark.org/Lua/Dissectors).

### Installation
* Clone this repository. 
```
git clone https://github.com/djin31/p4-traffictool.git
```
* Run `configure.sh` to check for dependencies.
* (Optional) Run `install.sh` to add the alias `p4-traffictool` to your bash configuration in order to avoid specifying the full path to `p4-traffictool.sh` script.

### Installation checks and tests (optional)
To perform a sanity check that the code produced by the tool is compatible with the tools available on your system you can use `./runtests.sh`. It runs the tool with a sample p4 program and its corresponding json file to produce scapy codes and checks that they are equivalent.
It then uses the generated scapy code to produce a pcap file `tests_data.pcap`. Then it generates the lua dissector and uses it with tshark to parse the pcap file and checks if the fields are parsed correctly.

Fulfilling all the above required tests prints `Tests passed`. This ensures that the tool is compatible with the wireshark and scapy installation on your system. If your system is missing `p4c` or `p4c-bm2-ss` then suitable error message is displayed before `Tests passed`.

Use `./runtests.sh clean` to wipe out all the code and pcap file generated from the tests directory.

## Usage

Use the top-level script _p4-traffictool.sh_ as following:
```
# With P4 program as the input
./p4-traffictool.sh -p4 <path to p4 source> [OPTIONS] [TARGET TOOL(S)]

# With json HLIR as the input
./p4-traffictool.sh -json <path to json HLIR description> [OPTIONS] [TARGET TOOL(S)]

# For help
./p4-traffictool.sh --help


[OPTIONS]
--std {p4-14|p4-16} : The P4 standard to use. Default is p4-16.
-o <output dir>     : Output directory path. Default is the same as the P4/json input file.
--debug             : Shows debugging information.


[TARGET TOOL(S)]
If no target tools are specified, user is prompted for each target tool.
Otherwise, user can specify one or more of the following:
--scapy --wireshark --moongen --pcpp
```
The above command will generate output files for specified target tool(s). The output files for each target tool will be placed in a subdirectory inside the _output directory_.

### Using the output files
The generated output files need to be integrated with the correponding tool(s). See [ToolSpecificUsage.md](docs/ToolSpecificUsage.md) for detailed steps.


### Additional User Inputs
* **Standard headers:** If standard headers for common protocols such as Ethernet, IPv4, IPv6, TCP, and UDP are detected by p4-traffictool, it will prompt the user if s/he wishes to use the original header/protocol implementations provided by the tool(s) instead of generating new implementations for them. An exception for this is the code generated for the Wireshark Lua dissector (see more details in [Nuances.md](docs/Nuances.md)).
* **Variable Length Fields:** Since there is limited support  available (and/or inconvenience of use) for variable length fields with Scapy, PcapPlusPlus and Wireshark Lua dissector, the tool prompts the user to enter the length of a variable length field when it detects one. This length should be a multiple of 8 to ensure that the header is byte aligned.
  * A fixed length field would be produced for the current run of p4-traffictool for Scapy, PcapPlusPlus and Wireshark Lua dissector. In order to modify this length, the user needs to rerun p4-traffictool. Note that this is a limitation of the target tools and p4-traffictool merely provides an option to choose the fixed length. 

## Nuances
While p4-traffictool works pretty well for most general cases, there are few tool-specific nuances and known issues. Please refer [Nuances.md](docs/Nuances.md) for details.


## Similar tools
[p4pktgen](https://github.com/p4pktgen/p4pktgen) is closely related to p4-traffictool. But the target usecases for the two tools are completely different. p4pktgen is a tool that is focused more towards testing all possible packet header combinations, whereas p4-traffictool is a tool which provides auto-generated code which the user can plug into popular traffic generation and parsing tools.

[P4 Wireshark Dissector](https://github.com/gnikol/P4-Wireshark-Dissector) also generates a Wireshark (Tshark) Lua dissector plugin for a given P4 program. However, a custom P4-defined layer can only be the last layer in the protocol stack. As a result, it supports a single custom layer in the protocol stack at a time. For example, suppose "foo" and "bar" are custom layers. Then using P4 Wireshark Dissector, you would be able to parse a packet of format `Ethernet/IP/UDP/foo` or `Ethernet/IP/bar`, but not of the format `Ethernet/IP/UDP/foo/bar` or `Ethernet/foo/bar`.
