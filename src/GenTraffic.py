import json
import sys

MAX_PATH_LENGTH = 10

ETHER_DETECT = False
IPv4_DETECT = False
IPv6_DETECT = False
TCP_DETECT = False
UDP_DETECT = False

try:
    data = json.load(open(sys.argv[1]))
    DESTINATION = sys.argv[2]
except:
    print "Incorrect argument specification"
    exit(0)
    
if (len(sys.argv)>3):
    try:
        MAX_PATH_LENGTH = int(sys.argv[3])
    except:
        print "Incorrect argument specification"
        exit(0)

def valid_name(state):
    if len(state["parser_ops"]) > 0:
        return state["parser_ops"][0]["parameters"][0]["value"]
    else:
        return state["name"]


def search_state(parser, name):
    for state in parser["parse_states"]:
        if (state["name"] == name):
            return valid_name(state)


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

def capitalise(s):
    return (s[:1].upper() + s[1:])

def check_checksum_fields(header_data, name):
    for chksum in (header_data["checksums"]):
        if (chksum["target"][0]==name):
            for calc in (header_data["calculations"]):
                if (calc["name"] == chksum["calculation"]):
                    fields = []
                    for i in calc["input"]:
                        fields.append(i["value"])
                    return(True, chksum["target"][1], fields, calc["algo"])
    return(False, None, None, None)
        
def make_header(header_data, header_id, fout):
    fout.write("class %s(Packet):\n" %(capitalise(data["headers"][header_id]['name'])))
    fout.write("\tname = '%s'\n" %(data["headers"][header_id]['name']))
    fout.write("\tfields_desc = [\n")
    for field in data["header_types"][header_id]['fields'][:-1]:
        fout.write("\t\tBitField('%s',0,%d),\n" % (field[0], field[1]))
    fout.write("\t\tBitField('%s',0,%d)\n" % (field[0], field[1]))
    fout.write("\t]\n")
    chksum,target,fields,algo = check_checksum_fields(header_data,data["headers"][header_id]['name'])
    if (chksum):
        fout.write("\t#update %s over %s using %s in post_build method\n\n" %(target,fields,algo))

def make_classes(header_data, fout):
    global ETHER_DETECT
    global IPv4_DETECT
    global IPv6_DETECT
    global TCP_DETECT
    global UDP_DETECT

    header_ports = []
    for header_id in range(len(data["header_types"])):
        if (data["headers"][header_id]['metadata']) == False:
            header_ports.append(data["headers"][header_id]['name'])
            if (data["headers"][header_id]['name']=='ethernet'):
                print("\n Ethernet header detected, would you like the standard ethernet header to be used(y/n) \n")
                temp = raw_input().strip()
                if (temp == 'y'):
                    ETHER_DETECT = True
                else:
                    make_header(header_data, header_id, fout)
            elif (data["headers"][header_id]['name']=='ipv4'):
                print("\n IPv4 header detected, would you like the standard ethernet header to be used(y/n) \n")
                temp = raw_input().strip()
                if (temp == 'y'):
                    IPv4_DETECT = True
                else:
                    make_header(header_data, header_id, fout)
            elif (data["headers"][header_id]['name']=='ipv6'):
                print("\n IPv6 header detected, would you like the standard ethernet header to be used(y/n) \n")
                temp = raw_input().strip()
                if (temp == 'y'):
                    IPv6_DETECT = True
                else:
                    make_header(header_data, header_id, fout)
            elif (data["headers"][header_id]['name']=='tcp'):
                print("\n TCP header detected, would you like the standard ethernet header to be used(y/n) \n")
                temp = raw_input().strip()
                if (temp == 'y'):
                    TCP_DETECT = True
                else:
                    make_header(header_data, header_id, fout)
            elif (data["headers"][header_id]['name']=='udp'):
                print("\n UDP header detected, would you like the standard ethernet header to be used(y/n) \n")
                temp = raw_input().strip()
                if (temp == 'y'):
                    UDP_DETECT = True
                else:
                    make_header(header_data, header_id, fout)
            else:
                make_header(header_data, header_id, fout)

    return header_ports


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

    for i in graph:
        print i
    return graph


def make_parsers(control_graph, header_ports, fout):
    for edge in control_graph:
        if (edge[0] in header_ports) and (edge[-1] in header_ports):
            fout.write("bind_layers(%s, %s, %s = %s)\n" % (
                capitalise(edge[0]), capitalise(edge[-1]), edge[1], edge[2]))


def string_packet(header_ports,packet):
    s = ""
    for i in packet:
        if i in header_ports:
            s += capitalise(i) + "()/"
    return s[:-2]

def make_packets(header_ports, init_states, control_graph, fout):
    paths = []
    for i in init_states:
        paths += possible_paths(i, control_graph, 0)
    paths = set(map(tuple,paths))
    paths = map(list,paths)
    if (len(paths) == 0):
        fout.write(
            "\n#No possible packets which can be parsed to the final state")
        return
    fout.write("_possible_packets_ = [\n")
    for i in paths[:-1]:
        fout.write("\t(%s)),\n" % (string_packet(header_ports,i)))
    fout.write("\t(%s))\n" % (string_packet(header_ports,paths[-1])))
    fout.write("]\n")

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

def make_template(json_data, destination):
    try:
        fout = open(destination, 'w')
        fout.write("from scapy import *\n")

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

make_template(data, DESTINATION)
