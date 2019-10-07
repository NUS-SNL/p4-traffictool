# Usage

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

## Using the output files
The generated output files need to be integrated with the correponding tool(s). See [ToolSpecificUsage.md](ToolSpecificUsage.md) for detailed steps.


## Additional User Inputs
* **Standard headers:** If standard headers for common protocols such as Ethernet, IPv4, IPv6, TCP, and UDP are detected by p4-traffictool, it will prompt the user if s/he wishes to use the original header/protocol implementations provided by the tool(s) instead of generating new implementations for them. An exception for this is the code generated for the Wireshark Lua dissector (see more details in [Nuances.md](Nuances.md)).
* **Variable Length Fields:** Since there is limited support  available (and/or inconvenience of use) for variable length fields with Scapy, PcapPlusPlus and Wireshark Lua dissector, the tool prompts the user to enter the length of a variable length field when it detects one. This length should be a multiple of 8 to ensure that the header is byte aligned.
  * A fixed length field would be produced for the current run of p4-traffictool for Scapy, PcapPlusPlus and Wireshark Lua dissector. In order to modify this length, the user needs to rerun p4-traffictool. Note that this is a limitation of the target tools and p4-traffictool merely provides an option to choose the fixed length. 
