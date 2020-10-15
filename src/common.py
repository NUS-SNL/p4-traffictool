#!/usr/bin/python
import json
import config
from typing import List, Tuple

def read_jsondata(filename):
    '''open file to load json data'''
    try:
        data = json.load(open(filename))
    except IOError:
        print ("Incorrect JSON file specification")
        exit(0)
    return data


def merge_padding(data):
    '''merges padding field with the next field'''
    for header_type in data["header_types"]:
        # try except added to prevent falling into error when scalars_0 has 0 fields
        try:
            temp_list = [header_type["fields"][0]]
            for i in range(1, len(header_type["fields"])):
                if (temp_list[-1][0][:4] == "_pad"):
                    temp_list = temp_list[:-1]
                    temp_list.append(
                        [header_type["fields"][i][0], header_type["fields"][i-1][1]+header_type["fields"][i][1]])
                else:
                    temp_list.append(header_type["fields"][i])
            header_type["fields"] = temp_list
        except:
            pass

    return data


def valid_state_name(state):
    '''assign valid name to state depending on which header it extracts'''
    if len(state["parser_ops"]) > 0:
        if type(state["parser_ops"][0]["parameters"][0]["value"]) is list:
            return state["parser_ops"][0]["parameters"][0]["value"][0]
        else:
            return state["parser_ops"][0]["parameters"][0]["value"]
    else:
        return state["name"]


def search_state(parser, name):
    '''search for valid state name in the parse states'''
    for state in parser["parse_states"]:
        if (state["name"] == name):
            return valid_state_name(state)


def search_header_type(header_types, name):
    '''search for header type given the header_type_name specified in header definition'''
    for header_type in header_types:
        if (header_type["name"] == name):
            return header_type


def make_control_graph(parsers: List[dict]) -> List[List]:
    '''make a control graph for all possible state transitions
    returns the list of edges in graph'''
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
    if (config.DEBUG):
        print("\nEdges in the control_graph\n")
        for i in graph:
            print(i)
    return graph


# TODO (pro-panda): define elements of list
def make_control_graph_multi(parsers: List[dict]) -> List[List]:
    graph = []
    for parser in parsers:
        for state in parser["parse_states"]:
            name = valid_state_name(state)
            if len(state["transition_key"]) > 0:
                for transition in state["transitions"]:
                    if transition["next_state"] != None:
                        # extract the headers which the transition is based on one of their fields
                        originHdr = [d["value"][0]
                                     for d in state["transition_key"]]
                        if(len(set(originHdr)) != 1):
                            print(
                                "Error: Header transitions based on multiple fields from different headers are not supported.")
                            exit(1)
                        # extract the fields which the transition is based on
                        transition_fields = [d["value"][1]
                                             for d in state["transition_key"]]
                        graph.append([name,
                                      transition_fields,
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
    if (config.DEBUG):
        print("\nEdges in the control_graph\n")
        for i in graph:
            print(i)
    return graph


def spaces(count):
    return (" " * count)


def gen_hex_mask(rbit_num, length):
    return hex(int('0b' + '1'*length + '0'*rbit_num, 2))


def sanitize_headers(headers: List[dict]) -> Tuple[List[str], List[dict]]:
    unique_headers = {}
    for header in headers:
        if header['metadata']:
            continue
        name = header['name']
        if name.find('[') != (-1):
            header['name'] = name[:name.find('[')]
        unique_headers[header['name']] = header
    return list(unique_headers.keys()), list(unique_headers.values())


def detect_builtin_hdr(headers: List[dict]) -> None:
    for header_id in range(len(headers)):
        if (headers[header_id]['name'] == 'ethernet'):
            temp = input(
                "\nEthernet header detected, would you like the standard ethernet header to be used(y/n) : ").strip()
            if (temp == 'y'):
                config.ETHER_DETECT = True
        elif (headers[header_id]['name'] == 'ipv4'):
            temp = input(
                "\nIPv4 header detected, would you like the standard IPv4 header to be used(y/n) : ").strip()
            if (temp == 'y'):
                config.IPv4_DETECT = True
        elif (headers[header_id]['name'] == 'ipv6'):
            temp = input(
                "\nIPv6 header detected, would you like the standard IPv6 header to be used(y/n) : ").strip()
            if (temp == 'y'):
                config.IPv6_DETECT = True
        elif (headers[header_id]['name'] == 'tcp'):
            temp = input(
                "\nTCP header detected, would you like the standard TCP header to be used(y/n) : ").strip()
            if (temp == 'y'):
                config.TCP_DETECT = True
        elif (headers[header_id]['name'] == 'udp'):
            temp = input(
                "\nUDP header detected, would you like the standard UDP header to be used(y/n) : ").strip()
            if (temp == 'y'):
                config.UDP_DETECT = True
    return


def nibble(size):
    if (size <= 8):
        return 2
    if (size <= 16):
        return 4
    if (size <= 24):
        return 6
    if (size <= 32):
        return 8
    if (size <= 40):
        return 10
    if (size <= 48):
        return 12
    if (size <= 56):
        return 14
    if (size <= 64):
        return 16
    raise ValueError("Size exceeds max limit for converting to nibble")

class State:
    def __init__(self, name):
        self.name = name
        self.children = []

    def print_state(self):
        print("node's name: ", self.name)
        print("node's children: ", [
              self.children[i].name for i in range(len(self.children))])


def delete_obj(del_list, orig_list):
    for item in del_list:
        orig_list.remove(item)


def find_children(root, nodes):
    if len(nodes) == 0:
        return
    else:
        children = []
        del_list = []
        for node in nodes:
            if node[0] == root.name:
                children.append(node[-1])
                del_list.append(node)
        delete_obj(del_list, nodes)
        children = set(children)
        for child in children:
            state = State(child)
            find_children(state, nodes)
            root.children.append(state)
        return


def make_tree(graph):
    paths = []
    state_names = [edge[0] for edge in graph]
    state_names = set(state_names)
    non_roots = [edge[-1] for edge in graph]
    non_roots = set(non_roots)
    for name in state_names:
        if name not in non_roots:
            root = State(name)
            find_children(root, graph)
            paths.append(root)
            root.print_state()
    return paths


def find_ethernet(node, rmv_headers, sub_headers):
    if (node.name == "ethernet" or node.name == "Ether") and config.ETHER_DETECT == True:
        find_eth_subhdr(node, sub_headers)
        return
    elif len(node.children) == 0:
        if node.name != "final":
            rmv_headers.append(node.name)
        return
    else:
        if node.name != "scalars" and node.name != "final":
            rmv_headers.append(node.name)
        for child in node.children:
            find_ethernet(child, rmv_headers, sub_headers)
        return
