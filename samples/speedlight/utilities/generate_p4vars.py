import sys

if len(sys.argv) < 4:
    print("Usage: generate_config.py outdir numports maxsnapshots")

numports = int(sys.argv[2])
max_snapshots = int(sys.argv[3])

with open(sys.argv[1] + "/config.p4", 'w') as outfile:
    # CPU constants must line up with control plane
    outfile.write("#define CPU_PORT 0\n")
    outfile.write("#define CPU_INGRESS_MIRROR_ID 98\n")
    outfile.write("#define CPU_EGRESS_MIRROR_ID 99\n")
    outfile.write("#define ETHERTYPE_TOCPU 0x88B6\n")

    # Bit width of variables
    # Change with header.p4 to accommodate larger or smaller counters/snapshots
    outfile.write("#define COUNTER_WIDTH 32\n")
    outfile.write("#define SNAPSHOT_ID_WIDTH 16\n")

    # Configuration variables
    outfile.write("#define NUM_PORTS %d\n" % (numports))
    outfile.write("#define MAX_SNAPSHOTS %d\n" % (max_snapshots))

    outfile.write("#define TWO_X_PORTS %d\n" % (numports * 2))
    outfile.write("#define TWO_X_PORTS_PLUS_CPU %d\n" % ((numports + 1) * 2))

    # PORTS_TBL_SIZE is the total number of ingress or egress counters
    # Must be NUM_PORTS + 1 because its hard to specify register[ingress_port - 1]
    # It's much easier to specify register[ingress_port]
    outfile.write("#define PORTS_TBL_SIZE %d\n" % (numports + 1))

    # NEIGHBORS_TBL_SIZE_ING/EGR is the last_seen neighbor table
    outfile.write("#define NEIGHBORS_TBL_SIZE_ING %d\n" % (numports * 2))
    outfile.write("#define NEIGHBORS_TBL_SIZE_EGR %d\n" % (numports * numports))

    # SSTABLE_SIZE is the number of entries in the snapshot table
    outfile.write("#define SSTABLE_SIZE %d\n" % (max_snapshots * numports))
    outfile.write("#define DOUBLE_SSTABLE_SIZE %d\n" % (((max_snapshots + 1) * (numports)*2) + 1))
