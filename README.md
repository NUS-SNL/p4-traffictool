# P4-TrafficGen

This is a tool to generate a [Scapy](https://scapy.net/) based packet generator for any given P4 program. The program accepts the json output of the p4c-bmv2 compiler for a p4 program as input and produces a python code which can be imported and instanciated to generate packets.

## Requirements
There are no dependencies as such required to run the code. The code can be run with both python2 as well as python3, though to make it compatible with python3 the python2 version would be a little (unnoticably) slower.

However to run the output python code you would need the Scapy package.

Also to generate the json file for the P4 program as expected by P4-TrafficGen you need [p4c](https://github.com/p4lang/p4c) compiler, specifically the [bmv2](https://github.com/p4lang/p4c/tree/master/backends/bmv2) backend.

## Usage
Firstly, you need the json description of your P4 program. To generate this from a P4 program:
```
p4c-bmv2 --json <desired name for json output> <path to p4 source>
```
You can also use 
```
p4c <path to p4 source>
```
if your code has dependencies on p4 libraries or header files like *core.h* or *v1model.h*

Now run the code:
```
python GenTraffic.py <path to json source> <destination> [-n max headers in packet]
```
The last argument is particularly useful in the cases of recurring states in the parser.
The output will be produced as

To generate packets import the generate code using:
```
from <source> import *
```
To access the list of all possible packets simply use the identifier *_possible_packets_*
