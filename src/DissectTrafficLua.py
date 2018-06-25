import json
import sys
import os

# global variables for common headers detection
# ETHER_DETECT = False
# IPv4_DETECT = False
# IPv6_DETECT = False
# TCP_DETECT = False
# UDP_DETECT = False

DEBUG = False

# open file to load json data
# fix destination path
try:
    data = json.load(open(sys.argv[1]))
    DESTINATION = sys.argv[2]
    if (DESTINATION[-1] != '/'):
        DESTINATION += '/'
    print ("Generating Lua packet dissector for %s at %s\n" %(sys.argv[1],DESTINATION))

except IndexError:
    print ("Incorrect argument specification")
    exit(0)
except IOError:
    print ("Incorrect file specification")
    exit(0)

# debug mode activated or not 
if (len(sys.argv) > 3):
    if (sys.argv[-1] == '-d'):
        DEBUG = True

# variable to store the tables created in the script
tables_created = []

# to remove duplicates while maintaining the same list order
def remove_duplicates(li):
    my_set = set(li)
    res = []
    for e in li:
        if e not in my_set:
            res.append(e)
            
    return res


def valid_state_name(state):
    if len(state["parser_ops"]) > 0:
        if type(state["parser_ops"][0]["parameters"][0]["value"]) is list:
            return state["parser_ops"][0]["parameters"][0]["value"][0]
        else:
            return state["parser_ops"][0]["parameters"][0]["value"]
    else:
        return state["name"]


def search_state(parser, name):
    for state in parser["parse_states"]:
        if (state["name"] == name):
            return valid_state_name(state)


def search_header_type(header_types, name):
    for header_type in header_types:
        if (header_type["name"] == name):
            return header_type


def find_data_headers(headers, header_types):
    # global ETHER_DETECT
    # global IPv4_DETECT
    # global IPv6_DETECT
    # global TCP_DETECT
    # global UDP_DETECT

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
            # Functionality for detection of common headers to be added
            # if (name=='ethernet'):
            #     print("\nEthernet header detected, would you like the standard ethernet header to be used(y/n) :")
            #     temp = input().strip()
            #     if (temp == 'y'):
            #         ETHER_DETECT = True
            # elif (name=='ipv4'):
            #     print("\nIPv4 header detected, would you like the standard ethernet header to be used(y/n) : ")
            #     temp = input().strip()
            #     if (temp == 'y'):
            #         IPv4_DETECT = True
            # elif (name=='ipv6'):
            #     print("\nIPv6 header detected, would you like the standard ethernet header to be used(y/n) : ")
            #     temp = input().strip()
            #     if (temp == 'y'):
            #         IPv6_DETECT = True
            # elif (name=='tcp'):
            #     print("\nTCP header detected, would you like the standard ethernet header to be used(y/n) : ")
            #     temp = input().strip()
            #     if (temp == 'y'):
            #         TCP_DETECT = True
            # elif (name=='udp'):
            #     print("\nUDP header detected, would you like the standard ethernet header to be used(y/n) :")
            #     temp = input().strip()
            #     if (temp == 'y'):
            #         UDP_DETECT = True
    header_ports = remove_duplicates(header_ports)

    header_types = []
    for i in header_ports:
        header_types.append(header_dict[i])

    if (DEBUG):
        print("\nHeaders \n")
        for i in range(len(header_ports)):
            print (header_ports[i], header_types[i]["name"])
    return (header_ports, header_types)


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


def make_template(control_graph, header, header_type, destination, header_ports):
    fout = open(destination, 'w')
    fout.write("-- protocol naming\n")
    fout.write("p4_proto = Proto('%s','%s')\n" %
               ("p4_"+header.lower(), "P4_"+header.upper() + "Protocol"))
    fout.write("\n-- protocol dissector function\n")
    fout.write("function p4_proto.dissector(buffer,pinfo,tree)\n")
    fout.write("\tpinfo.cols.protocol = '%s'\n" % ("P4_" + header.upper()))
    fout.write("\tlocal subtree = tree:add(p4_proto,buffer(),'%s Protocol Data')\n" % (
        "P4_" + header.upper()))

    next_state_key = ''
    transition_param = []
    for entry in control_graph:
        if (header == entry[0] and entry[1] != None):
            next_state_key = entry[1]
            break

    bit_count = 0
    byte_count = 0
    for field in header_type["fields"]:
        try:
            bitfield1, bitfield2 = bit_count, field[1]      
            bytefield1, bytefield2 = byte_count, int((bit_count + field[1])/8)
            if (field[0]==next_state_key):
                transition_param += [bytefield1,bytefield2,bitfield1,bitfield2]
            byte_count += int((bit_count + field[1])/8)
            if (field[1]%8!=0):
                bytefield2+=1
            bit_count = (bit_count + field[1])%8

            fout.write("\t\tsubtree:add(buffer(%d,%d), '%s (%d bits):' .. string.format('%s', tostring(buffer(%d,%d):bitfield(%d,%d))))\n" %(bytefield1,bytefield2,field[0],field[1],"%X",bytefield1,bytefield2,bitfield1,bitfield2))
        except TypeError:
            field[1] = int(input('Variable length field ' + field[0] + ' detected in ' + header + '. Enter its length\n'))
            bitfield1, bitfield2 = bit_count, field[1]      
            bytefield1, bytefield2 = byte_count, int((bit_count + field[1])/8)
            if (field[0]==next_state_key):
                transition_param += [bytefield1,bytefield2,bitfield1,bitfield2]
            byte_count += int((bit_count + field[1])/8)
            if (field[1]%8!=0):
                bytefield2+=1
            bit_count = (bit_count + field[1])%8

            fout.write("\t\tsubtree:add(buffer(%d,%d), '%s (%d bits):' .. string.format('%s', tostring(buffer(%d,%d):bitfield(%d,%d))))\n" %(bytefield1,bytefield2,field[0],field[1],"%X",bytefield1,bytefield2,bitfield1,bitfield2))
    if (DEBUG):
        print (header,header_type["name"], next_state_key, transition_param)

    if (next_state_key!='' and next_state_key!=None):
        try:
        	fout.write("\tlocal mydissectortable = DissectorTable.get('%s.%s')\n" %("p4_"+header, next_state_key,"P4_"+header.upper()))
            fout.write("\tmydissectortable:try(buffer(%d,%d):bitfield(%d,%d), buffer:range(%d):tvb(),pinfo,tree)\n" % (
                transition_param[0], transition_param[1], transition_param[2], transition_param[3], byte_count))
        except IndexError:
            fout.write("\t Could not detect suitable parameters\n")
            print ("Parameter error in %s, Please update the file to call next dissector with suitably\n" % (destination))
    fout.write("\nend\n")
    
    fout.write("\nprint( (require 'debug').getinfo(1).source )\n")

    fout.write("\n-- protocol registration\n")
    for entry in control_graph:
        if (header==entry[-1] and entry[0] in header_ports and entry[1]!=None):
            if (entry[0]!='ethernet'):
                fout.write("my_table = DissectorTable.get('%s.%s')\n" %("p4_"+entry[0], entry[1]))
                fout.write("my_table:add(%s,p4_proto)\n" %(entry[2]))
            else:
                fout.write("my_table = DissectorTable.get('ethertype')\n")
                fout.write("my_table:add(%s,p4_proto)\n" %(entry[2]))

    fout.write("\n-- creation of table for next layer(if required)\n")
    if (next_state_key!='' and next_state_key!=None):
        fout.write("\nlocal newdissectortable = DissectorTable.new('%s.%s','%s.%s',ftypes.STRING)" %("p4_"+header, next_state_key,"P4_"+header.upper(), next_state_key.upper()))
        tables_created.append((header,next_state_key))

control_graph = make_control_graph(data["parsers"])
header_ports, header_types = find_data_headers(data["headers"], data["header_types"])
fout = open(DESTINATION+"init.lua",'w')
local_name = sys.argv[1][sys.argv[1].rfind('/')+1:sys.argv[1].rfind('.')]

for i in range(len(header_ports)):
    if (header_ports[i]=='ethernet'):
        continue
    destination = DESTINATION + local_name + "_" + str(i) + "_" + header_ports[i] + ".lua"
    fout.write("dofile('%s')\n" %(os.path.abspath(destination)))
    make_template(control_graph, header_ports[i], header_types[i], destination, header_ports)

if (DEBUG):
    print ("\nTables created are\n")
    for i in tables_created:
        print (i)