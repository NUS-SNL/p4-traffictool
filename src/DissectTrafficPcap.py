import json
import sys
import os
from tabulate import tabulate
# global variables for common header types
ETHER_DETECT = False
IPv4_DETECT = False
IPv6_DETECT = False
TCP_DETECT = False
UDP_DETECT = False

DEBUG = False

# merges padding field with the next field
def merge_padding(data):
    for header_type in data["header_types"]:
        try:                                                        # try except added to prevent falling into error when scalars_0 has 0 fields
            temp_list=[header_type["fields"][0]]
            for i in range(1,len(header_type["fields"])):
                if (temp_list[-1][0][:4]=="_pad"):
                    temp_list=temp_list[:-1]
                    temp_list.append([header_type["fields"][i][0], header_type["fields"][i-1][1]+header_type["fields"][i][1]])
                else:
                    temp_list.append(header_type["fields"][i])
            header_type["fields"] = temp_list
        except:
            pass
        
    return data


# open file to load json data
# standardize destination path
try:
    data = merge_padding(json.load(open(sys.argv[1])))
    DESTINATION = sys.argv[2]
    if (DESTINATION[-1] != '/'):
        DESTINATION += '/'
        
except IndexError:
    print ("Incorrect argument specification")
    exit(0)
except IOError:
    print ("Incorrect file specification")
    exit(0)

# check if debug mode activated or not
if (len(sys.argv) > 3):
    if (sys.argv[-1] == '-d'):
        DEBUG = True

# variable to store the list of tables created by the scripts
tables_created = []

# assign valid name to state depending on which header it extracts
def valid_state_name(state):
    if len(state["parser_ops"]) > 0:
        if type(state["parser_ops"][0]["parameters"][0]["value"]) is list:
            return state["parser_ops"][0]["parameters"][0]["value"][0]
        else:
            return state["parser_ops"][0]["parameters"][0]["value"]
    else:
        return state["name"]

# search for valid state name in the parse states
def search_state(parser, name):
    for state in parser["parse_states"]:
        if (state["name"] == name):
            return valid_state_name(state)

# search for header type given the header_type_name specified in header definition
def search_header_type(header_types, name):
    for header_type in header_types:
        if (header_type["name"] == name):
            return header_type

# find headers and their types which appear within a packet i.e. are not metadata
def find_data_headers(headers, header_types):
    global ETHER_DETECT
    global IPv4_DETECT
    global IPv6_DETECT
    global TCP_DETECT
    global UDP_DETECT

    header_ports = []
    header_dict = {}

    for header_id in range(len(headers)):
        global input
        try:
            input = raw_input
        except NameError:
            pass
        if (headers[header_id]['metadata']) == False:
            name = headers[header_id]['name']
            if (name.find('[') != (-1)):
                name = name[:name.find('[')]
            header_ports.append(name)
            header_dict[name] = search_header_type(
                header_types, headers[header_id]["header_type"])

            # functionality to use common headers to be added
            if (name=='ethernet'):
                print("\nEthernet header detected, would you like the standard ethernet header to be used(y/n) :")
                temp = input().strip()
                if (temp == 'y'):
                    ETHER_DETECT = True
                    #print("\nAdd the next layers in the function parseNextLayer of PcapPlusPlus/Packet++/src/EthLayer.cpp\n")
            elif (name=='ipv4'):
                print("\nIPv4 header detected, would you like the standard IPv4 header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    IPv4_DETECT = True
                    #print("\nAdd the next layers in the function parseNextLayer of PcapPlusPlus/Packet++/src/IPv4Layer.cpp\n")

            elif (name=='ipv6'):
                print("\nIPv6 header detected, would you like the standard IPv6 header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    IPv6_DETECT = True
                    #print("\nAdd the next layers in the function parseNextLayer of PcapPlusPlus/Packet++/src/IPv6Layer.cpp\n")

            elif (name=='tcp'):
                print("\nTCP header detected, would you like the standard TCP header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    TCP_DETECT = True
                    #print("\nAdd the next layers in the function parseNextLayer of PcapPlusPlus/Packet++/src/TcpLayer.cpp\n")

            elif (name=='udp'):
                print("\nUDP header detected, would you like the standard UDP header to be used(y/n) :")
                temp = input().strip()
                if (temp == 'y'):
                    UDP_DETECT = True
                    #print("\nAdd the next layers in the function parseNextLayer of PcapPlusPlus/Packet++/src/UdpLayer.cpp\n")

    header_ports = list(set(header_ports))

    header_types = []
    for i in header_ports:
        header_types.append(header_dict[i])

    if (DEBUG):
        print("\nHeaders \n")
        for i in range(len(header_ports)):
            print (header_ports[i], header_types[i]["name"])

    require_correction=[]
    for i in range(len(header_types)):
        if ((ETHER_DETECT and header_ports[i]=='ethernet') or (IPv4_DETECT and header_ports[i]=='ipv4') or (IPv6_DETECT and header_ports[i]=='ipv6') or (TCP_DETECT and header_ports[i]=='tcp') or (UDP_DETECT and header_ports[i]=='udp')):
            continue
        else:
            header_type=header_types[i]
            corrected_data = {"name":header_type["name"], "fields":[]}
            for field in header_type["fields"]:
                try:
                    if (field[1]%8!=0):
                        corrected_data["fields"].append(field[0])
                except:
                    pass
            if len(corrected_data["fields"])>0:
                require_correction.append(corrected_data)
    if len(require_correction)>0:
        for incorrect_header in require_correction:
            print("ERROR: Non byte-aligned fields found in %s" %(str(incorrect_header["name"])))
            print("Correct the following fields to make them byte-aligned:")
            print(map(str,incorrect_header["fields"]))
        exit(1)
    return (header_ports, header_types)

# make a control graph for all possible state transitions
# returns the list of edges in graph
def make_control_graph(parsers):
    graph = []
    for parser in parsers:
        for state in parser["parse_states"]:
            name = valid_state_name(state)
            if len(state["transition_key"]) > 0:
                for transition in state["transitions"]:
                    if transition["next_state"] != None:
                        graph.append([name,
                                      state["transition_key"][0]["value"][1],
                                      transition["value"],
                                      search_state(
                                          parser, transition["next_state"])
                                      ])
                    else:
                        graph.append([name, None, None, "final"])
            else:
                if state["transitions"][0]["next_state"] != None:
                    graph.append([name, None, None, search_state(
                        parser, state["transitions"][0]["next_state"])])
                else:
                    graph.append([name, None, None, "final"])
    if (DEBUG):
        print("\nEdges in the control_graph\n")
        for i in graph:
            print(i)
    return graph

# copies template file contents 
def copy_template(fout):
    fin  = open("../templates/templateMoonGen.lua","r")
    l = fin.readlines()
    for i in l:
        fout.write(i)

# returns suitable datatype for the field
# currently promoting all fields to 8, 16, 32, or 64 bit fields
def predict_type(field):
    if (field<=8):
        return "uint8_t"
    if (field<=16):
        return "uint16_t"
    if (field<=24):
        return "uint24_t"
    if (field<=32):
        return "uint32_t"
    if (field<=40):
        return "uint40_t"
    if (field<=48):
        return "uint48_t"
    if (field<=64):
        return "uint64_t"
    return "-- fill blank here " + str(field)

def predict_input_type(field):
    if (field<=8):
        return "uint8_t"
    if (field<=16):
        return "uint16_t"
    if (field<=32):
        return "uint32_t"
    if (field<=64):
        return "uint64_t"

def network_host_conversion(field):
    if (field[1]<=8):
        return ""
    if (field[1]<=16):
        return "ntoh16"
    if (field[1]<=32):
        return "ntoh"
    if (field[1]<=64):
        return "ntoh64"
    return "-- fill blank here"

def host_network_conversion(field):
    if (field[1]<=8):
        return ""
    if (field[1]<=16):
        return "htons"
    if (field[1]<=32):
        return "htonl"
    if (field[1]<=64):
        return "htobe64"
    return "-- fill blank here"

# makes the actual lua script given the relevant header type and next and previous state transition information
def make_template(control_graph, header, header_type, destination, header_ports):
    
    headerUpper = header.upper()
    fout_header = open(destination + ".h","w")
    fout_source = open(destination + ".cpp","w")

    fout_header.write("//Template for addition of new protocol '%s'\n\n" %(header))
    fout_header.write("#ifndef %s\n" %("P4_"+header.upper()+"_LAYER"))
    fout_header.write("#define %s\n\n" %("P4_"+header.upper()+"_LAYER"))
    fout_header.write("#include \"Layer.h\"\n")
    fout_header.write('#include "uint24_t.h"\n#include "uint40_t.h"\n#include "uint48_t.h"\n')
    fout_header.write("#if defined(WIN32) || defined(WINx64)\n#include <winsock2.h>\n#elif LINUX\n#include <in.h>\n#endif\n\n")
    fout_header.write("namespace pcpp{\n\t#pragma pack(push,1)\n")
    fout_header.write("\tstruct %s{\n" %(header.lower()+"hdr"))
    
    for field in header_type["fields"]:
        try:
            fout_header.write("\t\t%s \t %s;\n" %(predict_type(field[1]),field[0]))
        except TypeError:
            field[1] = int(input('Variable length field "' + field[0] + '" detected in "' + header + '". Enter its length\n'))
            fout_header.write("\t\t%s \t %s;\n" %(predict_type(field[1]),field[0]))
    
    fout_header.write("\t};\n\n")

    fout_header.write("\t#pragma pack(pop)\n")
    fout_header.write("\tclass %sLayer: public Layer{\n" %(header.capitalize()))
    fout_header.write("\t\tpublic:\n")
    fout_header.write("\t\t %sLayer(uint8_t* data, size_t dataLen, Layer* prevLayer, Packet* packet): Layer(data, dataLen, prevLayer, packet) {m_Protocol = P4_%s;}\n" %(header.capitalize(), header.upper()))
   
    fout_header.write("\n\t\t // Getters and Setters for fields\n")

    for field in header_type["fields"]:
        fout_header.write("\t\t %s get%s();\n" %(predict_type(field[1]),str(field[0]).capitalize()))
        fout_header.write("\t\t void set%s(%s value);\n" %(str(field[0]).capitalize(),predict_input_type(field[1])))
    
    fout_header.write("\n\t\t inline %shdr* get%sHeader() { return (%shdr*)m_Data; }\n\n" %(header.lower(), header.capitalize(), header.lower()))
    fout_header.write("\t\t void parseNextLayer();\n\n")
    fout_header.write("\t\t inline size_t getHeaderLen() { return sizeof(%shdr); }\n\n" %(header.lower()))
    fout_header.write("\t\t void computeCalculateFields() {}\n\n")
    fout_header.write("\t\t std::string toString();\n\n")
    fout_header.write("\t\t OsiModelLayer getOsiModelLayer() { return OsiModelApplicationLayer; }\n\n")
    fout_header.write("\t};\n")
    fout_header.write("}\n#endif")
    fout_header.close()

    fout_source.write("#define LOG_MODULE PacketLogModule%sLayer\n\n" %(header.capitalize()))
    fout_source.write("#include \"%s.h\"\n" %(destination[destination.rfind('/')+1:]))
    fout_source.write("#include \"PayloadLayer.h\"\n#include \"IpUtils.h\"\n#include \"Logger.h\"\n")
    fout_source.write("#include <string.h>\n#include <sstream>\n#include <endian.h>\n\n")
    fout_source.write("namespace pcpp{\n")

    for field in header_type["fields"]:
        fout_source.write("\t%s %sLayer::get%s(){\n" %(predict_type(field[1]), header.capitalize(), str(field[0]).capitalize()))
        fout_source.write("\t\t%s %s;\n" %(predict_type(field[1]), field[0]))
        fout_source.write("\t\t%shdr* hdrdata = (%shdr*)m_Data;\n" %(header.lower(),header.lower()))
        if (field[1]==24 or field[1]==40 or field[1]==48):
            fout_source.write("\t\tUINT%d_HTON(hdrdata->%s,%s);\n" %(field[1], field[0], field[0]))
        else:
            fout_source.write("\t\t%s = %s(hdrdata->%s);\n" %(field[0],host_network_conversion(field), field[0]))
        fout_source.write("\t\treturn %s;\n\t}\n\n" %(field[0]))

        fout_source.write("\tvoid %sLayer::set%s(%s value){\n" %(header.capitalize(), str(field[0]).capitalize(), predict_input_type(field[1])))
        fout_source.write("\t\t%shdr* hdrdata = (%shdr*)m_Data;\n" %(header.lower(),header.lower()))
        if (field[1]==24 or field[1]==40 or field[1]==48):
            fout_source.write("\t\tUINT%d_HTON(value,hdrdata->%s);\n"%(field[1],field[0]))
        else:
            fout_source.write("\t\thdrdata->%s = %s(value);\n" %(field[0],host_network_conversion(field)))
        fout_source.write("\t}\n")
       
    default_next_transition = None
    transition_key = None
    next_transitions = []
    for edge in control_graph:
        if (header==edge[0]):
            if (edge[1]!=None):
                transition_key = edge[1]
                next_transitions.append((edge[-1],edge[-2]))
            else:
                default_next_transition = edge[-1]

    fout_source.write("\tvoid %sLayer::parseNextLayer(){\n" %(header.capitalize()))
    fout_source.write("\t\tif (m_DataLen <= sizeof(%shdr))\n" %(header.lower()))
    fout_source.write("\t\t\treturn;\n\n")

    if (len(next_transitions)>0):
        fout_source.write("\t\t%shdr* hdrdata = get%sHeader();\n" %(header.lower(), header.capitalize()))
        for field in header_type["fields"]:
            if (field[0]==transition_key):
                size = field[1]
                break
        fout_source.write("\t\t%s %s = %s(hdrdata->%s);\n\t\t" %(predict_type(field[1]), transition_key,host_network_conversion(field), transition_key))
        for transition in next_transitions[:-1]:
            #print transition
            fout_source.write("if (%s == %s)\n" %(transition_key, transition[1]))
            fout_source.write("\t\t\tm_NextLayer = new %sLayer(m_Data+sizeof(%shdr), m_DataLen - sizeof(%shdr), this, m_Packet);\n" %(transition[0].capitalize(),header.lower(), header.lower()))
            fout_source.write("\t\telse ")
        transition = next_transitions[-1]
        fout_source.write("if (%s == %s)\n" %(transition_key, transition[1]))
        fout_source.write("\t\t\tm_NextLayer = new %sLayer(m_Data+sizeof(%shdr), m_DataLen - sizeof(%shdr), this, m_Packet);\n" %(transition[0].capitalize(),header.lower(), header.lower()))

        if (default_next_transition!=None):
            fout_source.write("\t\telse\n")
            if (default_next_transition=="final"):
                fout_source.write("\t\t\tm_NextLayer = new PayloadLayer(m_Data + sizeof(%shdr), m_DataLen - sizeof(%shdr), this, m_Packet);\n" %(header.lower(),header.lower()))
            else:
                fout_source.write("\t\t\tm_NextLayer = new default_next_transition(m_Data + sizeof(%shdr), m_DataLen - sizeof(%shdr), this, m_Packet);\n" %(header.lower(),header.lower()))
    else:
        fout_source.write("\t\tm_NextLayer = new PayloadLayer(m_Data + sizeof(%shdr), m_DataLen - sizeof(%shdr), this, m_Packet);\n" %(header.lower(),header.lower()))

    fout_source.write("\t}\n")

    fout_source.write("\n\tstd::string %sLayer::toString(){ return ""; }\n\n" %(header.capitalize()))
    fout_source.write("}")


control_graph = make_control_graph(data["parsers"])
header_ports, header_types = find_data_headers(
    data["headers"], data["header_types"])
try:
    local_name = data["program"]
except KeyError:
    local_name = sys.argv[1]
local_name = local_name[local_name.rfind('/')+1:local_name.rfind('.')]


for i in range(len(header_ports)):
    if ((ETHER_DETECT and header_ports[i]=='ethernet') or (IPv4_DETECT and header_ports[i]=='ipv4') or (IPv6_DETECT and header_ports[i]=='ipv6') or (TCP_DETECT and header_ports[i]=='tcp') or (UDP_DETECT and header_ports[i]=='udp')):
        continue
    
    destination = DESTINATION + local_name + "_" + \
    header_ports[i]
    make_template(control_graph, header_ports[i], header_types[i], destination, header_ports)

if (DEBUG):
    print ("\nTables created\n")
    for i in tables_created:
        print (i)

# next header addition info
d={ 'ethernet':[],
    'ipv4':[],
    'ipv6':[],
    'tcp':[],
    'udp':[]
    }

file_map = { 
            'ethernet' : 'PcapPlusPlus/Packet++/src/EthLayer.cpp',
            'ipv4' : 'PcapPlusPlus/Packet++/src/IPv4Layer.cpp',
            'ipv6' : 'PcapPlusPlus/Packet++/src/IPv6Layer.cpp',
            'tcp' : 'PcapPlusPlus/Packet++/src/TcpLayer.cpp',
            'udp' : 'PcapPlusPlus/Packet++/src/UdpLayer.cpp'
            }
for i in range(len(control_graph)):
    edge=control_graph[i]
    if ((edge[0]=='ethernet' and ETHER_DETECT) or (edge[0]=='ipv4' and IPv4_DETECT) or (edge[0]=='ipv6' and IPv6_DETECT) or (edge[0]=='tcp' and TCP_DETECT) or (edge[0]=='udp' and UDP_DETECT)):
        d[edge[0]].append(edge[-1])

def remove_headers(l):
    l_dash=[]
    for i in l:
        if ((i=='final') or (i=='ethernet' and ETHER_DETECT) or (i=='ipv4' and IPv4_DETECT) or (i=='ipv6' and IPv6_DETECT) or (i=='tcp' and TCP_DETECT) or (i=='udp' and UDP_DETECT) )==False:
            l_dash.append(str(i))
    return l_dash
for k,v in d.iteritems():
    d[k]=remove_headers(d[k])
table=[[file_map[k],v] for k,v in d.iteritems() if len(v)>0]
print('\n')
print (tabulate(table, headers =['Standard headers\' src file to be modified', 'Headers to be added in parseNextLayer']))