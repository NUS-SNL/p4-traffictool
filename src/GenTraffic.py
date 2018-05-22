import json
import sys
MAX_PATH_LENGTH = 10
DESTINATION = "foo"

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


def make_classes(header_data, fout):
    header_ports = []
    for header_id in range(len(data["header_types"])):
        if (data["headers"][header_id]['metadata']) == False:
            header_ports.append(data["headers"][header_id]['name'])
            fout.write("class %s(Packet):\n" %
                       (data["headers"][header_id]['name'].capitalize()))
            fout.write("\tname = '%s'\n" %
                       (data["headers"][header_id]['name']))

            fout.write("\tfields_desc = [\n")
            for field in data["header_types"][header_id]['fields'][:-1]:
                fout.write("\t\tBitField('%s',0,%d),\n" % (field[0], field[1]))
            fout.write("\t\tBitField('%s',0,%d)\n" % (field[0], field[1]))
            fout.write("\t]\n\n")
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
                edge[0].capitalize(), edge[-1].capitalize(), edge[1], edge[2]))


def string_packet(packet):
    s = ""
    for i in packet[1:-1]:
        s += i.capitalize() + "()/"
    return s[:-2]

def make_packets(control_graph, fout):
    paths = possible_paths('start', control_graph, 0)
    if (len(paths) == 0):
        fout.write(
            "\n#No possible packets which can be parsed to the final state")
        return
    fout.write("_possible_packets = [\n")
    for i in paths[:-1]:
        fout.write("\t(%s)),\n" % (string_packet(i)))
    fout.write("\t(%s))\n" % (string_packet(paths[-1])))
    fout.write("]\n")


def make_template(json_data, destination):
    try:
        fout = open(destination, 'w')
        fout.write("from scapy import *\n")

        fout.write("\n ##class definitions\n")
        header_ports = make_classes(json_data, fout)

        fout.write("\n##bindings\n")
        control_graph = make_control_graph(json_data["parsers"])
        make_parsers(control_graph, header_ports, fout)

        fout.write("\n##packet_list\n")
        make_packets(control_graph, fout)
    catch:
        print("Destination file cannot be created\n")
        exit(0)

make_template(data, DESTINATION)
