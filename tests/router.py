from scapy.all import *
import json

data = json.load(open(sys.argv[1]))

for i in xrange(len(data["header_types"])):
	if (data["headers"][i]['metadata'])==False:
		print data["headers"][i]['name'] + "\n---------"
		for j in data["header_types"][i]['fields']:
			print j[0],j[1]
		print "-----------\n"

for i in xrange(len(data["parsers"][0]["parse_states"])):
	state = data["parsers"][0]["parse_states"][i]
	print state["name"]
	print state["transition_key"]
	for j in state["transitions"]:
		if j["next_state"]!=None:
			print j["type"],j["value"],j["next_state"]
		else:
			print "default to final state"
	print
