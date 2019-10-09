---
title: Nuances
layout: default
filename: Nuances
--- 

# Nuances
While p4-traffictool works pretty well for most general cases, there are few tool-specific nuances and known issues. 

## Tool-specific Nuances
* [Scapy](#scapy)
* [PcapPlusPlus](#pcapplusplus)
* [MoonGen](#moongen)
* [Wireshark (Tshark) Lua Dissector](#wireshark-tshark-lua-dissector)

## Scapy

### What the generated code provides
* Creates Scapy classes for the headers defined in the p4 program.
* Provides functionality for using Scapy's built-in standard headers.
* Detects variable length fields and points user to fill them suitably in class definition.
* Lastly, it produces a list of all possible packet combinations possible using the defined headers.


### What it doesn't
* Post build fields like length and checksums need to be defined by the user himself/herself in the post build method.
* All fields are treated as bitfields, user can modify them to support types such as int, short or any other suitable fields.

Usage details for Scapy can be found [here](ToolSpecificUsage.md#scapy).

## PcapPlusPlus

### What the generated code provides
* Creates files correponding to each protocol defining the header struct and the getter/setter functions.
* Provides functionality for using PcapPlusPlus' built-in standard headers.
* Detects variable length fields and prompts user to mention the size required for the current testbench.

### What it doesn't
* Post build fields like length and checksums need to be calculated in the setter function by the user.
* Field lengths which are not amongst {8, 16, 32, 64} shall be promoted to the next higher power of 2. If the user needs a field to be strictly of a particular size other than these, then a proper struct needs to be defined and corresponding _ntoh_ and _hton_ functions need to be defined.
* If using built-in headers (layers), then user needs to modify the `parseNextLayer()` function of the built-in header layer to include custom next layer(s).
* User needs to modify the ProtocolType.h file to include the new layers.

Usage details for PcapPlusPlus can be found [here](ToolSpecificUsage.md#pcapplusplus).

## MoonGen

### What the generated code provides
* Creates files correponding to each protocol defining the header struct, and getter and setter functions.
* Provides functionality for using MoonGen's built-in standard headers.

### What it doesn't
* Post build fields like length and checksums need to be calculated in the setter function by the user.
* Field lengths which are not amongst {8, 16, 24, 32, 40, 48, 64} shall be promoted to the next higher power of 2. If the user needs a field to be strictly of a particular size other than these then a proper struct needs to be defined and corresponding _ntoh_ and _hton_ functions need to be defined.
* If using built-in headers, then user need to modify the `resolveNextHeader()` function of the built-in header layer to include custom next layer(s).

Usage details for MoonGen can be found [here](ToolSpecificUsage.md#moongen).

## Wireshark (Tshark) Lua Dissector
### What the generated code provides
* Creates files correponding to each protocol defining the header struct.
* Detects variable length fields and prompts user to mention the size required for the current testbench.
* Generates an init file specifying the order in which to load the scripts.

### What it doesn't
* For parsing the packet correctly, user may need to disable the standard parsers of Wireshark.
* The tool expects that the user will be using Ethernet as the base layer and any modifications to the internet stack shall be present on top of it
* The tool does not provide support for using standard headers as of now

Usage details for Wireshark (Tshark) Lua Dissector can be found [here](ToolSpecificUsage.md#wireshark-tshark-lua-dissector).
