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
            elif (name=='ipv4'):
                print("\nIPv4 header detected, would you like the standard ethernet header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    IPv4_DETECT = True
            elif (name=='ipv6'):
                print("\nIPv6 header detected, would you like the standard ethernet header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    IPv6_DETECT = True
            elif (name=='tcp'):
                print("\nTCP header detected, would you like the standard ethernet header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    TCP_DETECT = True
            elif (name=='udp'):
                print("\nUDP header detected, would you like the standard ethernet header to be used(y/n) :")
                temp = input().strip()
                if (temp == 'y'):
                    UDP_DETECT = True
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
    fin  = open("../templates/templateMoonGen.lua","r")
    l = fin.readlines()
    for i in l:
        fout.write(i)

# makes the actual lua script given the relevant header type and next and previous state transition information
def make_template(control_graph, header, header_type, destination, header_ports):
    fout = open(destination,"w")
    fout.write("--Template for addition of new protocol '%s'\n\n" %(header))
    copy_template(fout)
    fout.write("\n\n--------------------------------\n")
    fout.write("---- %s header and constants \n" %(header.upper()))
    fout.write("--------------------------------\n")
    fout.write("local %s = {}\n\n" %(header.upper()))
    
    variable_fields = []
    fout.write("%s.headerFormat = [[\n" %(header.upper()))
    for field in header_type["fields"][:-1]:
        try:
            fout.write("\t%d \t %s;\n" %(field[1],field[0]))
        except TypeError:
            variable_fields.append(field[0])
    field = header_type["fields"][-1]
    try:
        fout.write("\t%d \t %s;\n" %(field[1],field[0]))
    except TypeError:
        variable_fields.append(field[0])
    fout.write("]]\n")
    fout.write("\n\n-- variable length fields\n")
    for variable_field in variable_fields:
        fout.write("%s.headerVariableMember = '%s'\n" %(header.upper(),variable_field))
    if len(variable_fields)==0:
        fout.write("%s.headerVariableMember = nil\n" %(header.upper()))
    fout.close()


control_graph = make_control_graph(data["parsers"])
header_ports, header_types = find_data_headers(
    data["headers"], data["header_types"])
# fout = open(DESTINATION+"init.lua", 'w')
local_name = sys.argv[1][sys.argv[1].rfind('/')+1:-5]
for i in range(len(header_ports)):
    destination = DESTINATION + local_name + "_" + \
        str(i) + "_" + header_ports[i] + ".lua"
    # fout.write("dofile('%s')\n" % (os.path.abspath(destination)))
    make_template(
        control_graph, header_ports[i], header_types[i], destination, header_ports)

if (DEBUG):
    print ("\nTables created\n")
    for i in tables_created:
        print (i)
