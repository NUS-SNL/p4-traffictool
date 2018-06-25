## Using Scapy Code

Import the generated code using
```
from <package name> import *
```

Therafter, you can generate packages using standard Scapy format. For eg. you want to generate a packet with layer _foo_ followed by layer _bar_ with payload _"foobar"_ , then:
```
a = Foo()/Bar()/"foobar"
```
will generate the required packet.

Also you can access a list of possible packet combinations using the keyword *possible_packets*

## Using Lua dissectors for Wireshark or Tshark

Firstly you need access to the personal plugins folder of your Wireshark installation.
To get a path to personal plugins folder open Wireshark, go to Help->About->Folders. 
(If the given path doesn;t exist then create a plugins folder at the given path so that you can add personal plugins in the future).

Append the contents of the init.lua file created to the init.lua file just outside your personal plugins folder 
(if it doesn't exist then copy the init.lua file at the path of your plugins folder)

If you no longer need these plugins then simply delete this part from the init file of your wireshark

Another method is to simply copy these scripts in your wireshark personal plugins folder.

That's it! Your plugins are ready to work. Restart Wireshark and open the pcap file which you wish to parse.

## Using PCapPlusPlus Code

Add the new protocols generated to Packet++/header/ProtocolType.h

If you used any default headers then add the corresponding next layer headers to the parseNextLayer function of the default header.

Copy the header files of new protocols to packet++/header and the cpp files to Packet++/source

## Using MoonGen Code

If you used any default headers then add the corresponding next layer headers to the resolveNextHeader function of the default header.

Add the new protocols to MoonGen/libmoon/lua/proto

Necessary changes to other files:
-- - packet.lua: if the header has a length member, adapt packetSetLength; 
-- 				 if the packet has a checksum, adapt createStack (loop at end of function) and packetCalculateChecksums
-- - proto/proto.lua: add PROTO.lua to the list so it gets loaded
