MAX_PATH_LENGTH =5
def possible_paths(init, control_graph, length_till_now):
	if (init=='final'): 
		return [['final']]
	if (length_till_now==MAX_PATH_LENGTH):
		return []

	temp = []
	possible_stops = [i[-1] for i in control_graph if i[0] == init]
	paths = []
	for i in possible_stops:
		temp+=(possible_paths(i, control_graph, length_till_now+1))
	for i in temp:
		paths.append([init] + i)
	return paths

graph =[
		['start', None, None, 'ethernet'],
		['ethernet', 'etherType', '0x0800', 'ipv4'],
		['ethernet', None, None, 'final'],
		['ethernet', None, None, 'ethernet'],
		['ipv4', 'protocol', '0x11', 'udp'],
		['ipv4', None, None, 'final'],
		['udp', 'dstPort', '0x1e61', 'q_meta'],
		['udp', 'dstPort', '0x22b8', 'snapshot'],
		['udp', None, None, 'final'],
		['q_meta', None, None, 'final'],
		['snapshot', None, None, 'final'],
		]

l = possible_paths('start',graph,0)
for i in l:
	print i