## Tool-specific Usage
* [Scapy](#scapy)
* [PcapPlusPlus](#pcapplusplus)
* [MoonGen](#moongen)
* [Wireshark (Tshark) Lua Dissector](#wireshark-tshark-lua-dissector)

## Scapy

[Scapy](https://scapy.net) is a powerful Python-based interactive packet manipulation program and library. The p4-traffictools generates code for Scapy such that your p4-defined protocol stack can be used in packet generation, packet capture, as well as parsing and dissecting packets (_on-wire_ or from a pcap file).

### Generating code for Scapy
Use the top-level script of `p4-traffictools.sh` as following
    
```    
./p4-traffictools.sh [-p4 <p4 src>] [-json <json file>] [--std {p4-14|p4-16}] [-o <dst dir>] --scapy
```
If standard headers (Ethernet, IPv4, etc.) are detected, the user will be asked if s/he wants to use Scapy's built-in headers instead of re-defining them.

#### Generated Code
The code for Scapy would be generated in the output directory inside a subdirectory "scapy". It consists of a single Python file which contains:
  * Scapy class definitions for custom headers defined in the P4 program.
  * Scapy bindings between standard and custom headers based on the parser defined in the P4 program.
  * A list of all possible packet combinations using the defined headers.

### Integration and Usage with Scapy
1. In your Python code that uses Scapy, import the generated Python file using
    ```
    from <filename> import *
    ```

2. Then, you can generate packets using standard Scapy format. For example, if you want to generate a packet with custom P4-defined layers _foo_ and _bar_ with payload _"foobar"_ , then:
    ```
    a = Foo()/Bar()/"foobar"
    ```
    will generate the required packet.

3. Also you can access a list of possible packet combinations using the variable *possible_packets_*
4. To send packets on the wire, use the `send()` or `sendp()` methods:
    ```
    sendp(a, iface=<netdev interface>)
    ```
5. For receiving or parsing packets, simply use the standard Scapy methods and it should now be able to recognize and show the custom P4-defined layers.

## PcapPlusPlus

[PcapPlusPlus](http://seladb.github.io/PcapPlusPlus-Doc) is a multiplatform C++ network sniffing and packet parsing and crafting framework. It provides a very fast and efficient method for crafting and parsing network packets.

1. Generate code for PcapPlusPlus backend
    ```
    ./p4-traffictools.sh [-h|--help] [-p4 <path to p4 source>] [-json <path to json description>] [--std {p4-14|p4-16}] [-o <path to destination dir>] [--pcpp] [--debug]
    ```

2. Add the new protocols generated to Packet++/header/ProtocolType.h

3. If you used any default headers then add the corresponding next layer headers to the parseNextLayer function of the default header.

4. Copy the header files of new protocols to packet++/header and the cpp files to Packet++/source

## MoonGen

[MoonGen](https://github.com/emmericp/MoonGen) is a scriptable high-speed packet generator built on libmoon. The whole load generator is controlled by a Lua script: all packets that are sent are crafted by a user-provided script.

1. Generate code for MoonGen backend
    ```
    ./p4-traffictools.sh [-h|--help] [-p4 <path to p4 source>] [-json <path to json description>] [--std {p4-14|p4-16}] [-o <path to destination dir>] [--moongen] [--debug]
    ```

2. Copy the new protocol files to MoonGen/libmoon/lua/proto/    

3. If you used any default headers then add the corresponding next layer headers to the resolveNextHeader function of the default header.
    ```
    Let's say you wanted to add protocol 'foo' on top of standard UDP layer. 
    Then you need to modify MoonGen/libmoon/lua/proto/udp.lua so that foo gets recognised while parsing udp packet.
    Search for the function resolveNextHeader within udp.lua. Over that you will find a map mapNamePort, 
    add FOO and the corresponding port number to this list.
    ```
    
    
4. Necessary changes to other files:
    - MoonGen/libmoon/lua/packet.lua: register the packet header combinations using createStack function
        ```
        Say you want to add layer foo over UDP. 
        Then inside packet.lua you need to define a getFooPacket function to generate a packet of foo protocol.
        
        pkt.getFooPacket = createStack("eth","ip4","udp","FOO")
        ```
        Apart from this you may need to incorporate following changes as well:
        -  if the header has a length member, adapt packetSetLength; 
        - if the packet has a checksum, adapt createStack (loop at end of function) and packetCalculateChecksums

     - MoonGen/libmoon/lua/proto/proto.lua: add PROTO.lua to the list so it gets loaded
     ```
     proto.<PROTOCOL NAME> = require "proto.<file containing protocol(remove .lua)>"
     ```

## Wireshark (Tshark) Lua Dissector

1. Generate code for Wireshark Lua dissector backend
    ```
    ./p4-traffictools.sh [-h|--help] [-p4 <path to p4 source>] [-json <path to json description>] [--std {p4-14|p4-16}] [-o <path to destination dir>] [--wireshark] [--debug]
    ```
2. To register the protocol with Wireshark or Tshark you need access to the personal plugins folder of your Wireshark installation.
    To get a path to personal plugins folder open Wireshark, go to Help->About->Folders. 
    (If the given path doesn;t exist then create a plugins folder at the given path so that you can add personal plugins in the future).

3. (Recommended method) Append the contents of the init.lua file created to the init.lua file just outside your personal plugins folder 
(if it doesn't exist then copy the init.lua file at the path of your plugins folder)

    If you no longer need these plugins then simply delete this part from the init file of your wireshark

4. Another method is to simply copy these scripts in your wireshark personal plugins folder.

    That's it! Your plugins are ready to work. Restart Wireshark and open the pcap file which you wish to parse.

