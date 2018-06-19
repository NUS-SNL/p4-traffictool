import json
import sys
import re

# Maximum possible headers within a packet, hyperparameter with default value as 10
MAX_PATH_LENGTH = 10

# global variables for common header types detection
ETHER_DETECT = False
IPv4_DETECT = False
IPv6_DETECT = False
TCP_DETECT = False
UDP_DETECT = False

DEBUG = False

# multi-headers stores headers that appear in the form of array 
# array_match is the regex to match for arrays
multi_headers = []
array_match = re.compile('[a-z A-Z 0-9 _ -]+''[''[0-9]+'']')

# open file to load json data
try:
    data = json.load(open(sys.argv[1]))
    DESTINATION = sys.argv[2]
    if DESTINATION[-1]!='/':
        DESTINATION+='/'
    print ("Generating Scapy traffic generator for %s at %s\n" %(sys.argv[1], DESTINATION))
except IndexError:
    print ("Incorrect argument specification")
    exit(0)
except IOError:
    print ("Incorrect file specification")
    exit(0)

# check if max path length has been set
if (len(sys.argv)>3):
    try:
        MAX_PATH_LENGTH = int(sys.argv[3])
    except ValueError:
        pass

# check if debug mode activated or not
if (len(sys.argv)>3):
    if (sys.argv[-1]=='-d'):
        DEBUG = True

# assign valid name to state depending on which header it extracts
def valid_name(state):
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
            return valid_name(state)

# search for header type given the header_type_name specified in header definition
def search_header_type(header_types, name):
    for header_type in header_types:
        if (header_type["name"] == name):
            return header_type

# find all possible header orderings that are valid
def possible_paths(init, control_graph, length_till_now):
    if (init == 'final'):
        return [['final']]
    if (length_till_now == MAX_PATH_LENGTH):
        return []
    temp = []
    possible_stops = [i[-1] for i in control_graph if i[0] == init]
    paths = []
    for i in possible_stops:
        temp += (possible_paths(i, control_graph, length_till_now+1))
    for i in temp:
        paths.append([init] + i)
    return paths

# correct names in case the header is of array form (instead of [X] replaces it with _X)
def correct_name(s):
    if (array_match.match(s)!=None):
        multi_headers.append(s[:s.find('[')])
        s = s[:s.find('[')]+ "_" + s[s.find('[')+1:s.rfind(']')]
    return s

# capitalise the first letter of name
def capitalise(s):
    s = correct_name(s)
    return (s[:1].upper() + s[1:])

# check if there any checksums fields, returns a tuple 
# (whether a checksum field exists, the target fields, fields over which checksum has to be calculated, checksum algorithm to use)
def check_checksum_fields(checksums, calculations, name):
    for chksum in (checksums):
        if (chksum["target"][0]==name):
            for calc in (calculations):
                if (calc["name"] == chksum["calculation"]):
                    fields = []
                    for i in calc["input"]:
                        try:
                            fields.append(i["value"])
                        except KeyError:
                            fields.append(i["type"])
                    return(True, chksum["target"][1], fields, calc["algo"])
    return(False, None, None, None)

# declares header fields and initialises them with default value zero, also specifies if there is any checksum fields which needs to be post-build
# other post-build fields need to be added manually
def make_header(headers, header_types, header_id, checksums, calculations, fout):
    fout.write("class %s(Packet):\n" %(capitalise(headers[header_id]['name'])))
    fout.write("\tname = '%s'\n" %(headers[header_id]['name']))
    fout.write("\tfields_desc = [\n")
    header_type = search_header_type(header_types, headers[header_id]["header_type"])
    for field in header_type['fields'][:-1]:
        try:
            fout.write("\t\tXBitField('%s',0,%d),\n" % (field[0], field[1]))
        except TypeError:
            print("Variable length field '%s' detected in header type '%s', fill in the template suitably\n" %(field[0], header_type['name']))
            fout.write("\t\tXBitField('%s',0,<insert length for variable field here or handle it in post_build>),\n" % (field[0]))
    if (len(header_type['fields'])>0):
        try:
            fout.write("\t\tXBitField('%s',0,%d)\n" % (header_type['fields'][-1][0], header_type['fields'][-1][1]))
        except TypeError:
            print("Variable length field '%s' detected in header type '%s', fill in the template suitably\n" %(header_type['fields'][-1][0], header_type['name']))
            fout.write("\t\tXBitField('%s',0,<insert length for variable field here or handle it in post_build>)\n" % (header_type['fields'][-1][0]))
    fout.write("\t]\n")
    chksum,target,fields,algo = check_checksum_fields(checksums, calculations, data["headers"][header_id]['name'])
    if (chksum):
        fout.write("\t#update %s over %s using %s in post_build method\n\n" %(target,fields,algo))

# defines various header types and check if any common header type can be substituted in its place, calls make_header function
def make_classes(data, fout):
    global ETHER_DETECT
    global IPv4_DETECT
    global IPv6_DETECT
    global TCP_DETECT
    global UDP_DETECT

    header_ports = []
    headers = data["headers"]
    header_types = data["header_types"]
    checksums = data["checksums"]
    calculations = data["calculations"]

    for header_id in range(len(headers)):
        global input
        try:
            input = raw_input
        except NameError:
            pass
        if (headers[header_id]['metadata']) == False:
            header_ports.append(correct_name(headers[header_id]['name']))
            if (headers[header_id]['name']=='ethernet'):
                print("\nEthernet header detected, would you like the standard ethernet header to be used(y/n) :")
                temp = input().strip()
                if (temp == 'y'):
                    ETHER_DETECT = True
                else:
                    make_header(headers, header_types, header_id, checksums, calculations, fout)
            elif (headers[header_id]['name']=='ipv4'):
                print("\nIPv4 header detected, would you like the standard ethernet header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    IPv4_DETECT = True
                else:
                    make_header(headers, header_types, header_id, checksums, calculations, fout)
            elif (headers[header_id]['name']=='ipv6'):
                print("\nIPv6 header detected, would you like the standard ethernet header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    IPv6_DETECT = True
                else:
                    make_header(headers, header_types, header_id, checksums, calculations, fout)
            elif (headers[header_id]['name']=='tcp'):
                print("\nTCP header detected, would you like the standard ethernet header to be used(y/n) : ")
                temp = input().strip()
                if (temp == 'y'):
                    TCP_DETECT = True
                else:
                    make_header(headers, header_types, header_id, checksums, calculations, fout)
            elif (headers[header_id]['name']=='udp'):
                print("\nUDP header detected, would you like the standard ethernet header to be used(y/n) :")
                temp = input().strip()
                if (temp == 'y'):
                    UDP_DETECT = True
                else:
                    make_header(headers, header_types, header_id, checksums, calculations, fout)
            else:
                make_header(headers, header_types, header_id, checksums, calculations, fout)

    if (DEBUG):
        print("\nHeaders \n")
        for i in header_ports:
            print (i)
        print("\nHeader arrays\n")
        for i in set(multi_headers):
            print (i)

    return header_ports

# make a control graph for all possible state transitions
# returns the list of edges in graph
def make_control_graph(parsers):
    graph = []
    for parser in parsers:
        for state in parser["parse_states"]:
            name = valid_name(state)
            if len(state["transition_key"]) > 0:
                for transition in state["transitions"]:
                    if transition["next_state"] != None:
                        graph.append([  name, 
                                        state["transition_key"][0]["value"][1], 
                                        transition["value"], 
                                        search_state(parser, transition["next_state"])
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

# defines bindings based on control graph
def make_parsers(control_graph, header_ports, fout):
    for edge in control_graph:
        if (edge[0] in header_ports) and (edge[-1] in header_ports) and (edge[1]!=None) and (edge[2]!=None):
            if (edge[2]!='default'): 
                fout.write("bind_layers(%s, %s, %s = %s)\n" % (capitalise(edge[0]), capitalise(edge[-1]), edge[1], edge[2]))
            else:
                fout.write("bind_layers(%s,%s)\n" %(capitalise(edge[0]), capitalise(edge[-1])))

# creates a string of the headers in a packet in a way that Scapy expects
def string_packet(header_ports,packet):
    s = ""
    for i in packet:
        if i in header_ports:
            s += capitalise(i) + "()/"
    return s[:-2]

# rectifies header names which are of array form
def rectify_paths(paths):
    for path_id in range(len(paths)):
        path = paths[path_id]
        distinct_state = set(path)
        multi_headers_loc = list(set(multi_headers))
        for i in distinct_state:
            if i in multi_headers_loc:
                count = 0
                for j in range(len(path)):
                    if (path[j]==i):
                        path[j]=path[j]+"_"+str(count)
                        count+=1
        paths[path_id] = path
    paths.sort(key=len)
    return paths

# prints the possible packet list into the file
def make_packets(header_ports, init_states, control_graph, fout):
    paths = []
    for i in init_states:
        paths += possible_paths(i, control_graph, 0)

    paths = set(map(tuple,paths))
    paths = list(map(list,paths))

    paths = rectify_paths(paths)

    if (DEBUG):
        print("\nPossible paths from start to accept state\n")
        for i in paths:
            print(i)
    if (len(paths) == 0):
        fout.write(
            "\n#No possible packets which can be parsed to the final state")
        return
    fout.write("possible_packets = [\n")
    for i in paths[:-1]:
        fout.write("\t(%s)),\n" % (string_packet(header_ports,i)))
    fout.write("\t(%s))\n" % (string_packet(header_ports,paths[-1])))
    fout.write("]\n")

# rectifies array names for inbuilt header types
def change_names(header_ports, control_graph, init_states, old, new):
    for i in range(len(header_ports)):
        if (header_ports[i]==old):
            header_ports[i]=new
    for i in range(len(control_graph)):
        if (control_graph[i][0]==old):
            control_graph[i][0]=new
        if (control_graph[i][-1]==old):
            control_graph[i][-1]=new
    for i in range(len(init_states)):
        if (init_states[i]==old):
            init_states[i]=new
    return (header_ports,control_graph,init_states)                

def correct_metadata(header_ports, control_graph, init_states):
    if (ETHER_DETECT):
        (header_ports,control_graph,init_states) = change_names(header_ports, control_graph, init_states, "ethernet", "Ether")
    if (IPv4_DETECT):
        (header_ports,control_graph,init_states) = change_names(header_ports, control_graph, init_states, "ipv4", "IP")
    if (IPv6_DETECT):
        (header_ports,control_graph,init_states) = change_names(header_ports, control_graph, init_states, "ipv6", "IPv6")
    if (TCP_DETECT):
        (header_ports,control_graph,init_states) = change_names(header_ports, control_graph, init_states, "tcp", "TCP")
    if (UDP_DETECT):
        (header_ports,control_graph,init_states) = change_names(header_ports, control_graph, init_states, "udp", "UDP")
    return (header_ports,control_graph,init_states) 

# top level module that calls other functions, accepts the json_data and the file destination as input
def make_template(json_data, destination):
    try:
        fout = open(destination, 'w')
        fout.write("from scapy.all import *\n")

        fout.write("\n##class definitions\n")
        header_ports = make_classes(json_data, fout)

        #building metadata
        control_graph = make_control_graph(json_data["parsers"])
        init_states = []
        for parser in json_data["parsers"]:
            init_states.append(search_state(parser,parser["init_state"]))
        (header_ports,control_graph,init_states) = correct_metadata(header_ports,control_graph,init_states) 
            
        fout.write("\n##bindings\n")
        make_parsers(control_graph, header_ports, fout)

        fout.write("\n##packet_list\n")
        make_packets(header_ports, init_states, control_graph, fout)

    except IOError:
        print("Destination file cannot be created\n")
        exit(0)

make_template(data, DESTINATION+sys.argv[1][sys.argv[1].rfind('/')+1:-5]+".py")
