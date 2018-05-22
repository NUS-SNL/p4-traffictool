import json

data = json.load(open(sys.argv[1]))

def make_classes(header_data, fout):
	for header_id in xrange(len(data["header_types"])):	
		if (data["headers"][header_id]['metadata'])==False:
			fout.write("class " + data["headers"][header_id]['name'] +"(Packet):\n")
			fout.write("\tname = " + data["headers"][header_id]['name']+ "\n")
			
			fout.write("\tfields_desc = [\n")
			for field in data["header_types"][header_id]['fields']:
				fout.write("\t\tBitField()")				
				print field[0],field[1]


def make_template(json_data, destination):
	fout = open(destination,'w')
	fout.write("from scapy import *\n")
	fout.write("\n ##class definitions\n")
	make_classes(json_data, fout)



for header_id in xrange(len(data["header_types"])):
	if (data["headers"][header_id]['metadata'])==False:
		print data["headers"][header_id]['name'] + "\n---------"
		for field in data["header_types"][header_id]['fields']:
			print field[0],field[1]
		print "-----------\n"

for parser_index in data["parsers"]:
	for state in (parser_index["parse_states"]):
		print state["name"]
		if len(state["transition_key"])>0:
			print state["transition_key"][0]["value"]
		for transition in state["transitions"]:
			if transition["next_state"]!=None:
				print transition["type"],transition["value"],transition["next_state"]
			else:
				print "default to final state"
		print

