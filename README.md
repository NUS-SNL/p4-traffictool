# p4-traffictool
p4-traffictool helps in packet generation, parsing and dissection for popular backends. It supports code generation for [Scapy](https://scapy.net), [PcapPlusPlus](https://github.com/seladb/PcapPlusPlus), [MoonGen](https://github.com/emmericp/MoonGen/) and [Wireshark (Tshark)](https://wiki.wireshark.org/Lua/Dissectors).

p4-traffictool converts your p4 code to `bmv2` JSON file using the [p4c](https://github.com/p4lang/p4c) compiler and processes it to generate output code. This adds a limitation that your code should compile with p4c.<br>
As a hack to support other targets / architectures, you need to extract your headers and parser logic and modify it to fit in a template available at `/usr/share/p4-traffictool/templates/template.p4`.

p4-traffictool was presented as a poster in SOSR 2019 - https://dl.acm.org/doi/10.1145/3314148.3318047.

## Installation
p4-traffictool requires [p4c](https://github.com/p4lang/p4c) compiler installed and accessible by running the `p4c` command in bash.

### Building from source
Clone this repository and run `./install.sh`.

### PPAs
PPAs are available for Ubuntu 16.04 and 18.04,

```shell
sudo add-apt-repository ppa:pro-panda/p4-traffictool
sudo apt-get update
sudo apt install p4-traffictool
```

## Usage
```
# With P4 program as the input
./p4-traffictool -p4 <path to p4 source> [OPTIONS] [TARGET TOOL(S)]

# With json HLIR as the input
./p4-traffictool -json <path to json HLIR description> [OPTIONS] [TARGET TOOL(S)]

# For help
./p4-traffictool --help

[OPTIONS]
--std {p4-14|p4-16} : The P4 standard to use. Default is p4-16.
-o <output dir>     : Output directory path. Default is the same as the P4/json input file.
--debug             : Shows debugging information.


[TARGET TOOL(S)]
--scapy --wireshark --moongen --pcpp --all
```

### Standard headers
If standard headers for Ethernet, IPv4, IPv6, TCP, and UDP are detected, the user will be prompted to choose between using the protocol implementations provided by the tools (except Wireshark) or generating new implementations for them.
### Variable Length Fields
There is limited support for variable length fields with Scapy, PcapPlusPlus and Wireshark. p4-traffictool prompts the user to enter the length of a variable length field when it detects one. This length should be a multiple of 8 to ensure that the header is byte aligned.<br>
A fixed length field would be produced for the current run of p4-traffictool for Scapy, PcapPlusPlus and Wireshark Lua dissector. In order to modify this length, the user needs to rerun p4-traffictool.

## Scapy
[Scapy](https://scapy.net) is a powerful Python-based interactive packet manipulation program and library.

### Usage
1. In your Python code that uses Scapy, import the generated Python file using
    ```
    from <filename> import *
    ```

2. Then, you can generate packets using standard Scapy format. For example, if you want to generate a packet with custom P4-defined layers _foo_ and _bar_ with payload _"foobar"_ , then:
    ```
    a = Foo()/Bar()/"foobar"
    ```
    will generate the required packet.


### What it doesn't offer
* Post build fields like length and checksums need to be defined by the user himself/herself in the post build method.
* All fields are treated as bitfields, user can modify them to support types such as int, short or any other suitable fields.

## Wireshark (Tshark) Lua Dissector

### Usage
To open wireshark with your custom plugins imported into it,
```shell
wireshark -X lua_script:init.lua 
```

To extract field values from the packets captured in a pcap file using tshark with your custom plugins enabled.
```
tshark -X lua_script:init.lua -r captured_packets.pcap -Tfields -e <field_name>
```

### What it doesn't offer
* The tool expects that the user will be using Ethernet as the base layer and any modifications to the internet stack shall be present on top of it
* The tool does not provide support for using standard headers as of now

## PcapPlusPlus
[PcapPlusPlus](http://seladb.github.io/PcapPlusPlus-Doc) is a multiplatform C++ network sniffing and packet parsing/crafting framework. It provides a very fast and efficient method for crafting and parsing network packets.

### Usage
1. Copy the files `uint24_t.h`,`uint40_t.h` and `uint48_t.h` from `/usr/share/p4-traffictool/templates/` to `Packet++/header` inside your PcapPlusPlus source tree. These files contain definitions for 24, 40 and 48 bit datatypes.

2. Copy the header (.h) files of custom P4-defined protocol(s) to `Packet++/header` directory and the C++ (.cpp) files to `Packet++/source` directory inside your PcapPlusPlus source tree.

3. If you have used any standard PcapPlusPlus headers (e.g. Ethernet, IPv4, etc.) and if any of the new custom headers are the "next" layers, then add the new custom headers to the `parseNextLayer` function of the standard header.
   * For example, if a new custom header _foo_ appears after the Ethernet layer and is identified by etherType `0x123`, then add a new switch case inside the function `EthLayer::parseNextLayer()` in `Packet++/src/EthLayer.cpp`. 

4. Add the newly generated protocol(s) to the `enum ProtocolType` inside `Packet++/header/ProtocolType.h`. The `enum ProtocolType` specifies a separate bit for each protocol. So if the already defined last protocol in the `enum ProtocolType` has value 0x20000000, then to add a newly generated protocol _foo_, add `P4_FOO = 0x40000000` to the enum.

5. Now recompile PcapPlusPlus and also install it (if you are accessing it from a central location):
```shell
make clean
make all [-j4]
sudo make install
```

6. For using the new P4-defined layers in your PcapPlusPlus application", simply include the header (.h) files of the required layer(s) in your C++ program and call the constructor, getters, setters, etc. in the usual way of using PcapPlusPlus.

### What it doesn't offer
* Post build fields like length and checksums need to be calculated in the setter function by the user.
* Field lengths which are not amongst {8, 16, 32, 64} shall be promoted to the next higher power of 2. If the user needs a field to be strictly of a particular size other than these, then a proper struct needs to be defined and corresponding _ntoh_ and _hton_ functions need to be defined.
* If using built-in headers (layers), then user needs to modify the `parseNextLayer()` function of the built-in header layer to include custom next layer(s).
* User needs to modify the ProtocolType.h file to include the new layers.

## MoonGen
[MoonGen](https://github.com/emmericp/MoonGen) is a Lua-based high-speed packet generator.

### Usage
0. Copy the file `templates/bitfields_def.lua` to the directory `MoonGen/libmoon/lua/`. This is just a one-time requirement. This file contains struct definitions for 24, 40 and 48 bits fields.
1. Copy the newly generated protocol files (Lua files) to MoonGen/libmoon/lua/proto/    

2. If you used any default headers then add the corresponding next layer headers to the `resolveNextHeader` function of the default header.
   * Let's say you want to add protocol _foo_ on top of the standard UDP layer. Then you need to modify MoonGen/libmoon/lua/proto/udp.lua so that _foo_ gets recognized while parsing the UDP packet. Search for the function `resolveNextHeader` in the file udp.lua. Over that you will find a map `mapNamePort`. Add the pair `foo = udp.PORT_FOO` to the map. Here, `udp.PORT_FOO` is a constant defined in the same file (udp.lua).
    
3. In the file MoonGen/libmoon/lua/packet.lua, register the packet header combinations using the `createStack` function.
   * Say you have defined the layer _foo_ over UDP. Then inside the file packet.lua you need to define a `getFooPacket` function to generate a packet of the _foo_ protocol:
     ```lua
     pkt.getFooPacket = createStack("eth","ip4","udp","FOO")
     ```
4. Additional changes in MoonGen/libmoon/lua/packet.lua may also be required:
   * if the header has a length field that depends on the next layer's length, then adapt the function `packetSetLength` 
   * if the packet has a checksum, adapt `createStack` (the loop at end of function `createStack`) and `packetCalculateChecksums`

5. Add your protocol to MoonGen/libmoon/lua/proto/proto.lua so that it gets loaded : 
     ```lua
     proto.<protocol name> = require "proto.<file containing protocol without the .lua extension>"
     ```
   * For example, the _foo_ protocol could be added as following:
     ```lua
     proto.foo = require "proto.foo"
     ```
6. Now you can run any of the examples (or otherwise scripts) in MoonGen by using the function `get<ProtoName>Packet()` instead of the usual `getUdpPacket()`.
   * For example, to get a packet of the protocol _foo_, use `getFooPacket()` which was defined in step #3 above.

### What it doesn't offer
* Post build fields like length and checksums need to be calculated in the setter function by the user.
* Field lengths which are not amongst {8, 16, 24, 32, 40, 48, 64} shall be promoted to the next higher power of 2. If the user needs a field to be strictly of a particular size other than these then a proper struct needs to be defined and corresponding _ntoh_ and _hton_ functions need to be defined.
* If using built-in headers, then user need to modify the `resolveNextHeader()` function of the built-in header layer to include custom next layer(s).


## License
[MIT License](LICENSE)
