import sys
# from config import *
# Flags for CPU notifications.  There are 3 flag bits:
# 1: New Snapshot
# 2: New Neighbor Last Seen
# 3: Ingress = 0 / Egress = 1
CPU_NEWSS_NEWNBR_INGRESS = 0b110
CPU_NEWSS_INGRESS = 0b100
CPU_NEWNBR_INGRESS = 0b010

CPU_NEWSS_NEWNBR_EGRESS = 0b111
CPU_NEWSS_EGRESS = 0b101
CPU_NEWNBR_EGRESS = 0b011

def main(PROGRAM, ports, snapshots):
    output = open('includes/commands.txt','w')
    install_ingress_rules(PROGRAM, ports, snapshots, output)
    install_egress_rules(PROGRAM, ports, snapshots, output)
    install_mirror_rules(output)

def is_newss_notification(flag):
    return flag & 0b100
def is_newls_notification(flag):
    return flag & 0b010
def is_egress_notification(flag):
    return flag & 0b001

def install_mirror_rules(output):
    output.write("mirroring_add 98 0\n")
    output.write("mirroring_add 99 0\n")

def install_ingress_rules(PROGRAM, ports, snapshots, output):
    tiCheckOption.setup(PROGRAM, ports, snapshots, output)
    tiSetEffectivePort.setup(PROGRAM, ports, snapshots, output)
    if ('_W' in PROGRAM) or ('_WC' in PROGRAM):
        tiUpdateLastSeen.setup(PROGRAM, ports, snapshots, output)
        tiCheckRollover.setup(PROGRAM, ports, snapshots, output)
        tiSetSnapshotCaseNoRollover.setup(PROGRAM, ports, snapshots, output)
        tiSetSnapshotCaseRollover.setup(PROGRAM, ports, snapshots, output)
    else:
        tiSetSnapshotCase.setup(PROGRAM, ports, snapshots, output)

    if '_WC' in PROGRAM:
        tiUpdateSnapshotValue.setup(PROGRAM, ports, snapshots, output)
        tiSendNotificationWithChannelState.setup(PROGRAM, ports, snapshots, output)
    else:
        tiTakeSnapshot.setup(PROGRAM, ports, snapshots, output)
        tiSendNotification.setup(PROGRAM, ports, snapshots, output)

    tiForwardInitiation.setup(PROGRAM, ports, snapshots, output)

def install_egress_rules(PROGRAM, ports, snapshots, output):
    teSetEffectivePort.setup(PROGRAM, ports, snapshots, output)
    if ('_W' in PROGRAM) or ('_WC' in PROGRAM):
        teUpdateLastSeen.setup(PROGRAM, ports, snapshots, output)
        teCheckRollover.setup(PROGRAM, ports, snapshots, output)
        teSetSnapshotCaseNoRollover.setup(PROGRAM, ports, snapshots, output)
        teSetSnapshotCaseRollover.setup(PROGRAM, ports, snapshots, output)
    else:
        teSetSnapshotCase.setup(PROGRAM, ports, snapshots, output)

    if '_WC' in PROGRAM:
        teUpdateSnapshotValue.setup(PROGRAM, ports, snapshots, output)
        teSendNotificationWithChannelState.setup(PROGRAM, ports, snapshots, output)
    else:
        teTakeSnapshot.setup(PROGRAM, ports, snapshots, output)
        teSendNotification.setup(PROGRAM, ports, snapshots, output)

    teFinalizePacket.setup(PROGRAM, ports, snapshots, output)

class tiCheckOption(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_set_default tiCheckOption aiCheckOption 0\n')
        output.write('table_add tiCheckOption aiCheckOption 31 => 1\n')
        output.write('table_add tiCheckOption aiCheckOption 30 => 2\n')


class tiSetEffectivePort(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        for x in xrange(1, ports + 1):
            output.write('table_add tiSetEffectivePort aiSetEffectivePort 1 ' + str(x) + '&&&0xFFFF => ' + str(x) + ' 1\n')
            output.write('table_add tiSetEffectivePort aiSetEffectivePort 0 ' + str(x) + '&&&0xFFFF => ' + str(x) + ' 1\n')
        
        output.write('table_add tiSetEffectivePort aiFakeEffectivePort 2 0&&&0x0000 => 1\n')

class tiUpdateLastSeen(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        for x in xrange(1, ports + 1):
            output.write('table_add tiUpdateLastSeen aiUpdateLastSeen ' + str(x) + '&&&0xFF 2&&&0xFF => ' +  str(tiUpdateLastSeen.get_index(x, 2)) + ' 1\n')
            output.write('table_add tiUpdateLastSeen aiUpdateLastSeen ' + str(x) + '&&&0xFF 1&&&0xFF => ' +  str(tiUpdateLastSeen.get_index(x, 1)) + ' 1\n')

    @staticmethod
    def get_index(port_num, snapshot_feature):
        if snapshot_feature == 2:
            return ((port_num - 1) * 2)
        else:
            return ((port_num - 1) * 2 + 1)

class tiCheckRollover(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_add tiCheckRollover aCheckRollover 1 => \n')
        output.write('table_add tiCheckRollover aCheckRollover 2 => \n')

class tiSetSnapshotCaseNoRollover(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_set_default tiSetSnapshotCaseNoRollover aSetSnapshotCase 2\n')
        output.write('table_add tiSetSnapshotCaseNoRollover aSetSnapshotCase 0&&&0xFFFF 0&&&0xFFFF 0&&&0xFFFF => 0 1\n')
        output.write('table_add tiSetSnapshotCaseNoRollover aSetSnapshotCase 0&&&0xFFFF 0&&&0xFFFF 1&&&0x0000 => 1 2\n')
        output.write('table_add tiSetSnapshotCaseNoRollover aSetSnapshotCase 0&&&0xFFFF 1&&&0x0000 0&&&0xFFFF => 2 3\n')

class tiSetSnapshotCaseRollover(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_add tiSetSnapshotCaseRollover aSetSnapshotCase 0&&&0xFFFF 1&&&0x0000 1&&&0x0000 => 1 1\n')
        output.write('table_add tiSetSnapshotCaseRollover aSetSnapshotCase 1&&&0x0000 0&&&0xFFFF 0&&&0xFFFF => 0 2\n')
        output.write('table_add tiSetSnapshotCaseRollover aSetSnapshotCase 1&&&0x0000 0&&&0xFFFF 1&&&0x0000 => 1 3\n')
        output.write('table_add tiSetSnapshotCaseRollover aSetSnapshotCase 1&&&0x0000 1&&&0x0000 0&&&0xFFFF => 2 4\n')

class tiSetSnapshotCase(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_add tiSetSnapshotCase aSetSnapshotCase 0&&&0xFFFF 0&&&0xFFFF => 0 1\n')
        output.write('table_add tiSetSnapshotCase aSetSnapshotCase 0&&&0xFFFF 1&&&0x0000 => 1 2\n')
        output.write('table_add tiSetSnapshotCase aSetSnapshotCase 1&&&0x0000 0&&&0xFFFF => 2 3\n')

class tiTakeSnapshot(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        for snapshot_id in xrange(0, snapshots + 1):
            for port in xrange(1, ports + 1):
                output.write('table_add tiTakeSnapshot aiTakeSnapshot 1 ' + str(snapshot_id) + ' ' + str(port) + ' => ' + \
                    str(tiTakeSnapshot.get_index(snapshot_id, ports, port)) + '\n')

    @staticmethod
    def get_index(snapshot_id, max_port_num, port):
        return snapshot_id * max_port_num + port - 1

class tiUpdateSnapshotValue(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_add tiUpdateSnapshotValue aNoOp 2 2&&&0xFF 0&&&0x0000 0&&&0x0000 0&&&0x0000 => 1\n')
        for snapshot_id in xrange(0, snapshots + 1):
            for port in xrange(1, ports + 1):
                output.write('table_add tiUpdateSnapshotValue aiTakeSnapshot 1 0&&&0x0000 ' + str(snapshot_id) + '&&&0xFFFF 0&&&0x0000 ' + str(port) + '&&&0xFFFF => ' + str(tiUpdateSnapshotValue.get_index(snapshot_id, ports, port)) + ' 2\n')
                output.write('table_add tiUpdateSnapshotValue aiUpdateInflight 2 0&&&0x0000 0&&&0x0000 ' + str(snapshot_id) + '&&&0xFFFF ' + str(port) + '&&&0xFFFF => ' + str(tiUpdateSnapshotValue.get_index(snapshot_id, ports, port)) + ' 3\n')

    @staticmethod
    def get_index(snapshot_id, max_port_num, port):
        return snapshot_id * max_port_num + port - 1

class tiSendNotification(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        global CPU_NEWSS_INGRESS
        output.write('table_add tiSendNotification aiSendNotification 1 => ' + str(CPU_NEWSS_INGRESS) + '\n')

class tiSendNotificationWithChannelState(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        global CPU_NEWSS_NEWNBR_INGRESS
        global CPU_NEWSS_INGRESS
        global CPU_NEWNBR_INGRESS

        output.write('table_set_default tiSendNotificationWithChannelState aNoOp\n')
        output.write('table_add tiSendNotificationWithChannelState aNoOp 0&&&0xFFFF 0&&&0x00 0&&&0x00 => 1\n')
        output.write('table_add tiSendNotificationWithChannelState aiSendNotification 0&&&0x0000 1&&&0xFF 1&&&0xFF => ' + str(CPU_NEWSS_NEWNBR_INGRESS) + ' 2\n')
        output.write('table_add tiSendNotificationWithChannelState aiSendNotification 0&&&0x0000 0&&&0x00 1&&&0xFF => ' + str(CPU_NEWSS_INGRESS) + ' 3\n')
        output.write('table_add tiSendNotificationWithChannelState aiSendNotification 0&&&0x0000 1&&&0xFF 0&&&0x00 => ' + str(CPU_NEWNBR_INGRESS) + ' 4\n')

class tiForwardInitiation(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        for port in xrange(1, ports+ 1):
            output.write('table_add tiForwardInitiation aiForwardInitiation ' + str(port) + ' => ' + str(port) + "\n")

class teSetEffectivePort(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        for x in xrange(1, ports + 1):
            output.write('table_add teSetEffectivePort aeSetEffectivePort ' + str(x) + ' => ' + str(x) + ' \n')

class teUpdateLastSeen(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        total_entries = ports * ports
        for current_port in xrange(1, ports + 1):
            index = teUpdateLastSeen.get_index(current_port, ports, 0)
            output.write('table_add teUpdateLastSeen aeUpdateLastSeen ' + str(current_port) + ' 0&&&0x0000 30&&&0xFF => ' +  str(index) + ' ' + str(total_entries - index) + '\n')
            for from_port in xrange(1, ports+ 1):
                if (current_port == from_port):
                    continue
                index = teUpdateLastSeen.get_index(current_port, ports, from_port)
                output.write('table_add teUpdateLastSeen aeUpdateLastSeen ' + str(current_port) + ' ' + str(from_port) + '&&&0xFFFF 0&&&0x00 => ' +  str(index) + ' ' + str(total_entries - index) + ' \n')
    @staticmethod
    def get_index(current_port, max_port_num, from_port):
        if (from_port < current_port):
            return (current_port - 1) * max_port_num + from_port
        else:
            return (current_port - 1) * max_port_num + from_port - 1

class teCheckRollover(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_add teCheckRollover aCheckRollover 1 => \n')
        output.write('table_add teCheckRollover aCheckRollover 2 => \n')

class teSetSnapshotCaseNoRollover(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_set_default teSetSnapshotCaseNoRollover aSetSnapshotCase 2\n')
        output.write('table_add teSetSnapshotCaseNoRollover aSetSnapshotCase 0&&&0xFFFF 0&&&0xFFFF 0&&&0xFFFF => 0 1\n')
        output.write('table_add teSetSnapshotCaseNoRollover aSetSnapshotCase 0&&&0xFFFF 0&&&0xFFFF 0&&&0x0000 => 1 2\n')
        output.write('table_add teSetSnapshotCaseNoRollover aSetSnapshotCase 0&&&0xFFFF 0&&&0x0000 0&&&0xFFFF => 2 3\n')

class teSetSnapshotCaseRollover(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_add teSetSnapshotCaseRollover aSetSnapshotCase 0&&&0xFFFF 1&&&0x0000 1&&&0x0000 => 1 1\n')
        output.write('table_add teSetSnapshotCaseRollover aSetSnapshotCase 1&&&0x0000 0&&&0xFFFF 0&&&0xFFFF => 0 2\n')
        output.write('table_add teSetSnapshotCaseRollover aSetSnapshotCase 1&&&0x0000 0&&&0xFFFF 1&&&0x0000 => 1 3\n')
        output.write('table_add teSetSnapshotCaseRollover aSetSnapshotCase 1&&&0x0000 1&&&0x0000 0&&&0xFFFF => 2 4\n')

class teSetSnapshotCase(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_add teSetSnapshotCase aSetSnapshotCase 0&&&0xFFFF 0&&&0xFFFF => 0 1\n')
        output.write('table_add teSetSnapshotCase aSetSnapshotCase 0&&&0xFFFF 1&&&0x0000 => 1 2\n')
        output.write('table_add teSetSnapshotCase aSetSnapshotCase 1&&&0x0000 0&&&0xFFFF => 2 3\n')

class teTakeSnapshot(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        for snapshot_id in xrange(0, snapshots + 1):
            for port in xrange(1, ports + 1):
                output.write('table_add teTakeSnapshot aeTakeSnapshot 1 ' + str(snapshot_id) + ' ' + str(port) + ' => ' + \
                    str(teTakeSnapshot.get_index(snapshot_id, ports, port)) + '\n')

    @staticmethod
    def get_index(snapshot_id, max_port_num, port):
        return snapshot_id * max_port_num + port - 1

class teSendNotification(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        global CPU_NEWSS_EGRESS
        output.write('table_add teSendNotification aeSendNotification 1 => ' + str(CPU_NEWSS_EGRESS) + '\n')

class teSendNotificationWithChannelState(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        global CPU_NEWSS_NEWNBR_EGRESS
        global CPU_NEWSS_EGRESS
        global CPU_NEWNBR_EGRESS

        output.write('table_set_default teSendNotificationWithChannelState aeSendNotification ' + str(CPU_NEWNBR_EGRESS) + ' \n')
        output.write('table_add teSendNotificationWithChannelState aNoOp 0&&&0xFFFF 0&&&0x00 0&&&0x00 => 1\n')
        output.write('table_add teSendNotificationWithChannelState aeSendNotification 0&&&0x0000 30&&&0xFF 1&&&0xFF => ' + str(CPU_NEWSS_EGRESS) + ' 2\n')
        output.write('table_add teSendNotificationWithChannelState aeSendNotification 0&&&0x0000 0&&&0x00 1&&&0xFF => ' + str(CPU_NEWSS_NEWNBR_EGRESS) + ' 3\n')
        output.write('table_add teSendNotificationWithChannelState aNoOp 0&&&0x0000 30&&&0xFF 0&&&0x00 => 4\n')

class teUpdateSnapshotValue(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_add teUpdateSnapshotValue aNoOp 2 2&&&0xFF 0&&&0x0000 0&&&0x0000 0&&&0x0000 => 1\n')
        for snapshot_id in xrange(0, snapshots + 1):
            for port in xrange(1, ports + 1):
                output.write('table_add teUpdateSnapshotValue aeTakeSnapshot 1 0&&&0x0000 ' + str(snapshot_id) + '&&&0xFFFF 0&&&0x0000 ' + str(port) + '&&&0xFFFF => ' + str(teUpdateSnapshotValue.get_index(snapshot_id, ports, port)) + ' 2\n')
                output.write('table_add teUpdateSnapshotValue aeUpdateInflight 2 0&&&0x0000 0&&&0x0000 ' + str(snapshot_id) + '&&&0xFFFF ' + str(port) + '&&&0xFFFF => ' + str(teUpdateSnapshotValue.get_index(snapshot_id, ports, port)) + ' 3\n')

    @staticmethod
    def get_index(snapshot_id, max_port_num, port):
        return snapshot_id * max_port_num + port - 1

class teFinalizePacket(object):
    @staticmethod
    def setup(PROGRAM, ports, snapshots, output):
        output.write('table_set_default teFinalizePacket aeUpdateSnapshotHeader\n')
        output.write('table_add teFinalizePacket aeDropPacket 30 0&&&0x0000 => 1\n')



if __name__ == "__main__":
    if (len(sys.argv) != 4):
        print 'Incorrect input arguments: PROGRAM_NAME, NUMBER OF PORTS, NUMBER OF SNAPSHOTS'
        sys.exit(1)


    PROGRAM = sys.argv[1]
    ports = sys.argv[2]
    snapshots = sys.argv[3]   
    main(PROGRAM, int(ports), int(snapshots))