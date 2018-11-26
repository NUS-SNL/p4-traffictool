from foobar import *

a = Ether()/IP()/UDP(sport=3120)/Foo(flow_id=1234,ingress_tstamp=4242,egress_tstamp=2121)
wrpcap('tests_data.pcap',a/"DATA", append=True)
a = Ether()/IP()/UDP(sport=3120)/Bar(flow_id=1234,ingress_tstamp=4242,egress_tstamp=2121)