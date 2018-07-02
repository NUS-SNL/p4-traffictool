import json
import sys
import os

# global variables for common header types
ETHER_DETECT = False
IPv4_DETECT = False
IPv6_DETECT = False
TCP_DETECT = False
UDP_DETECT = False

DEBUG = False

# open file to load json data
# standardize destination path
try:
    data = json.load(open(sys.argv[1]))
    DESTINATION = sys.argv[2]
    if (DESTINATION[-1] != '/'):
        DESTINATION += '/'
    print ("Generating MoonGen traffic generator for %s at %s\n" %(sys.argv[1],DESTINATION))

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
                    print("\nAdd the next layers in the function resolveNextHeader of MoonGen/libmoon/lua/proto/ethernet.lua (if they are not default)\n")
            elif (name=='ipv4'):
                print("\nIPv4 header detected, would you like the standard IPv4 header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    IPv4_DETECT = True
                    print("\nAdd the next layers in the function resolveNextHeader of MoonGen/libmoon/lua/proto/ip4.lua (if they are not default)\n")

            elif (name=='ipv6'):
                print("\nIPv6 header detected, would you like the standard IPv6 header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    IPv6_DETECT = True
                    print("\nAdd the next layers in the function resolveNextHeader of MoonGen/libmoon/lua/proto/ip6.lua (if they are not default)\n")

            elif (name=='tcp'):
                print("\nTCP header detected, would you like the standard TCP header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    TCP_DETECT = True
                    print("\nAdd the next layers in the function resolveNextHeader of MoonGen/libmoon/lua/proto/tcp.lua (if they are not default)\n")

            elif (name=='udp'):
                print("\nUDP header detected, would you like the standard UDP header to be used(y/n) :")
                temp = input().strip()
                if (temp == 'y'):
                    UDP_DETECT = True
                    print("\nAdd the next layers in the function resolveNextHeader of MoonGen/libmoon/lua/proto/udp.lua (if they are not default)\n")

    header_ports = list(set(header_ports))

    header_types = []
    for i in header_ports:
        header_types.append(header_dict[i])

    if (DEBUG):
        print("\nHeaders \n")
        for i in range(len(header_ports)):
            print (header_ports[i], header_types[i]["name"])
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
    pathname = os.path.abspath(os.path.dirname(sys.argv[0]))
    fin  = open(pathname + "/../templates/templateMoonGen.lua","r")
    l = fin.readlines()
    for i in l:
        fout.write(i)

def predict_type(field):
    if (field[1]<=8):
        return "uint8_t"
    if (field[1]<=16):
        return "uint16_t"
    if (field[1]<=24):
        return "union bitfield_24"
    if (field[1]<=32):
        return "uint32_t"
    if (field[1]<=40):
        return "union bitfield_40"
    if (field[1]<=48):
        return "union bitfield_48"
    if (field[1]<=64):
        return "uint64_t"
    return "-- fill blank here " + str(field[1])

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
        return "hton16"
    if (field[1]<=24):
        return ""
    if (field[1]<=32):
        return "hton"
    if (field[1]<=40):
        return ""
    if (field[1]<=48):
        return ""
    if (field[1]<=64):
        return "hton64"
    return "-- fill blank here"

# makes the actual lua script given the relevant header type and next and previous state transition information
def make_template(control_graph, header, header_type, destination, header_ports):
    
        headerUpper = header.upper()
        fout = open(destination,"w")
        fout.write("--Template for addition of new protocol '%s'\n\n" %(header))
        copy_template(fout)
        fout.write("\n\n-----------------------------------------------------\n")
        fout.write("---- %s header and constants \n" %(headerUpper))
        fout.write("-----------------------------------------------------\n")
        fout.write("local %s = {}\n\n" %(headerUpper))
        
        variable_fields = []
        fout.write("%s.headerFormat = [[\n" %(headerUpper))
        for field in header_type["fields"][:-1]:
            try:
                fout.write("\t%s \t %s;\n" %(predict_type(field),field[0]))
            except TypeError:
                variable_fields.append(field[0])
        field = header_type["fields"][-1]
        try:
            fout.write("\t%s \t %s;\n" %(predict_type(field),field[0]))
        except TypeError:
            variable_fields.append(field[0])
        fout.write("]]\n")
        fout.write("\n\n-- variable length fields\n")
        for variable_field in variable_fields:
            fout.write("%s.headerVariableMember = '%s'\n" %(headerUpper,variable_field))
        if len(variable_fields)==0:
            fout.write("%s.headerVariableMember = nil\n" %(headerUpper))

        fout.write("\n-- Module for %s_address struct\n" %(headerUpper))
        fout.write("local %sHeader = initHeader()\n" % (headerUpper))
        fout.write("%sHeader.__index = %sHeader\n\n" %(headerUpper,headerUpper))
        fout.write("\n-----------------------------------------------------\n")
        fout.write("---- Getters, Setters and String functions for fields")
        fout.write("\n-----------------------------------------------------\n")

        for field in header_type["fields"]:
            if (not(predict_type(field).startswith("union")) and field[1]<65):
                fout.write("function %sHeader:get%s()\n" %(headerUpper, field[0].upper()))
                fout.write("\treturn %s(self.%s)\n" %(host_network_conversion(field),field[0]))
                fout.write("end\n\n")

                fout.write("function %sHeader:get%sstring()\n" %(headerUpper, field[0].upper()))
                fout.write("\treturn self:get%s()\n" %(field[0].upper()))
                fout.write("end\n\n")

                fout.write("function %sHeader:set%s(int)\n" %(headerUpper, field[0].upper()))
                fout.write("\tint = int or 0\n")
                fout.write("\tself.%s = %s(int)\n" %(field[0],host_network_conversion(field)))
                fout.write("end\n\n\n")
            else:
                fout.write("function %sHeader:get%s()\n" %(headerUpper, field[0].upper()))
                fout.write("\treturn (self.%s:get())\n" %(field[0]))
                fout.write("end\n\n")

                fout.write("function %sHeader:get%sstring()\n" %(headerUpper, field[0].upper()))
                fout.write("\treturn self:get%s()\n" %(field[0].upper()))
                fout.write("end\n\n")

                fout.write("function %sHeader:set%s(int)\n" %(headerUpper, field[0].upper()))
                fout.write("\tint = int or 0\n")
                fout.write("\tself.%s:set(int)\n" %(field[0]))
                fout.write("end\n\n\n")                

        fout.write("\n-----------------------------------------------------\n")
        fout.write("---- Functions for full header")
        fout.write("\n-----------------------------------------------------\n")
        fout.write("-- Set all members of the PROTO header\n")
        fout.write("function %sHeader:fill(args,pre)\n" %(headerUpper))
        fout.write("\targs = args or {}\n")
        fout.write("\tpre = pre or '%s'\n\n" %(headerUpper))

        for field in header_type["fields"]:
            fout.write("\tself:set%s(args[pre .. '%s'])\n" %(field[0].upper(), field[0].upper()))
        fout.write("end\n\n")

        fout.write("-- Retrieve the values of all members\n")
        fout.write("function %sHeader:get(pre)\n" %(headerUpper))
        fout.write("\tpre = pre or '%s'\n\n" %(headerUpper))
        fout.write("\tlocal args = {}\n")
        for field in header_type["fields"]:
            fout.write("\targs[pre .. '%s'] = self:get%s()\n" %(field[0].upper(), field[0].upper()))
        fout.write("\n\treturn args\nend\n\n")

        fout.write("function %sHeader:getString()\n" %(headerUpper))
        fout.write("\treturn '%s \\n'\n" %(headerUpper))
        for field in header_type["fields"]:
            fout.write("\t\t.. '%s' .. self:get%sString() .. '\\n'\n" %(field[0].upper(), field[0].upper()))
        fout.write("end\n\n")

        default_next_transition = None
        transition_key = None
        next_transitions = []
        for edge in control_graph:
            if (header==edge[0]):
                if (edge[1]!=None ):
                    transition_key = edge[1]
                    next_transitions.append((edge[-1],edge[-2]))
                elif (str(edge[-1])!='final'):
                    default_next_transition = edge[-1]
        fout.write("-- Dictionary for next level headers\n")
        fout.write("local nextHeaderResolve = {\n")
        for transition in next_transitions:
            fout.write("\t%s = %s,\n" %(transition[0].upper(),transition[1]))
        fout.write("}\n")



        fout.write("function %sHeader:resolveNextHeader()\n" %(headerUpper))
        if (len(next_transitions)>0):
            fout.write("\tlocal key = self:get%s()\n" %(transition_key.upper()))
            fout.write("\tfor name, value in pairs(nextHeaderResolve) do\n")
            fout.write("\t\tif key == value then\n\t\t\treturn name\n\t\tend\n\tend\n")
        if (default_next_transition!= None):
            fout.write("\treturn %s\n" %(default_next_transition))
        else:
            fout.write("\treturn nil\n")
        fout.write("end\n\n")

        fout.write("\n-----------------------------------------------------\n")
        fout.write("---- Metatypes")
        fout.write("\n-----------------------------------------------------\n")
        fout.write("ffi.metatype('union bitfield_24',bitfield24)\nffi.metatype('union bitfield_40',bitfield40)\nffi.metatype('union bitfield_48',bitfield48)")
        fout.write("%s.metatype = %sHeader\n" %(headerUpper, headerUpper))
        fout.write("\nreturn %s" %(headerUpper))

        fout.close()



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
        header_ports[i] + ".lua"
    make_template(
        control_graph, header_ports[i], header_types[i], destination, header_ports)


if (ETHER_DETECT or IPv4_DETECT or IPv6_DETECT or TCP_DETECT or UDP_DETECT):
    next_layer = {}
    for edge in control_graph:
        if (edge[-1]!='final'):
            if (edge[0] in next_layer):
                next_layer[edge[0]].append(edge[-1])
            else:
                next_layer[edge[0]]=[edge[-1]]

