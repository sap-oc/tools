#!/bin/bash

DHCP_RANGE_END_OLD='192.168.177.80'
DHCP_RANGE_END_NEW='192.168.177.50'

HOST_RANGE_START_OLD='192.168.177.81'
HOST_RANGE_START_NEW='192.168.177.51'
HOST_RANGE_END_OLD='192.168.177.160'
HOST_RANGE_END_NEW='192.168.177.180'

SWITCH_RANGE_START_OLD='192.168.177.241'
SWITCH_RANGE_START_NEW='192.168.177.251'
SWITCH_RANGE_END_OLD='192.168.177.250'
SWITCH_RANGE_END_NEW='192.168.177.251'

BMC_RANGE_START_OLD='192.168.177.162'
BMC_RANGE_START_NEW='192.168.177.182'
BMC_RANGE_END_OLD='192.168.177.240'
BMC_RANGE_END_NEW='192.168.177.182'

BMC_VLAN_RANGE_START_OLD='192.168.177.161'
BMC_VLAN_RANGE_START_NEW='192.168.177.181'
BMC_VLAN_RANGE_END_OLD='192.168.177.161'
BMC_VLAN_RANGE_END_NEW='192.168.177.181'

ROLE_NAME_SUFFIX='virtual_cloud_suse_de'


mkdir roles.old roles.new

for role in network-config-default $(knife role list | grep $ROLE_NAME_SUFFIX); do

	knife role show -F json $role > roles.old/$role.json

        sed "s/\"end\": \"$DHCP_RANGE_END_OLD\"/\"end\": \"$DHCP_RANGE_END_NEW\"/g;
             s/\"start\": \"$HOST_RANGE_START_OLD\"/\"start\": \"$HOST_RANGE_START_NEW\"/g;
             s/\"end\": \"$HOST_RANGE_END_OLD\"/\"end\": \"$HOST_RANGE_END_NEW\"/g;
             s/\"start\": \"$SWITCH_RANGE_START_OLD\"/\"start\": \"$SWITCH_RANGE_START_NEW\"/g;
             s/\"end\": \"$SWITCH_RANGE_END_OLD\"/\"end\": \"$SWITCH_RANGE_END_NEW\"/g;
             s/\"start\": \"$BMC_RANGE_START_OLD\"/\"start\": \"$BMC_RANGE_START_NEW\"/g;
             s/\"end\": \"$BMC_RANGE_END_OLD\"/\"end\": \"$BMC_RANGE_END_NEW\"/g;
             s/\"start\": \"$BMC_VLAN_RANGE_START_OLD\"/\"start\": \"$BMC_VLAN_RANGE_START_NEW\"/g;
             s/\"end\": \"$BMC_VLAN_RANGE_END_OLD\"/\"end\": \"$BMC_VLAN_RANGE_END_NEW\"/g;" \
        roles.old/$role.json > roles.new/$role.json

	# not yet...
	knife role from file roles.new/$role.json
done


mkdir databag.old databag.new

for net in admin bmc bmc_vlan; do

	knife data bag show -F json crowbar ${net}_network > databag.old/${net}_network.json

	sed "s/\"end\": \"$DHCP_RANGE_END_OLD\"/\"end\": \"$DHCP_RANGE_END_NEW\"/g;
             s/\"start\": \"$HOST_RANGE_START_OLD\"/\"start\": \"$HOST_RANGE_START_NEW\"/g;
             s/\"end\": \"$HOST_RANGE_END_OLD\"/\"end\": \"$HOST_RANGE_END_NEW\"/g;
             s/\"start\": \"$SWITCH_RANGE_START_OLD\"/\"start\": \"$SWITCH_RANGE_START_NEW\"/g;
             s/\"end\": \"$SWITCH_RANGE_END_OLD\"/\"end\": \"$SWITCH_RANGE_END_NEW\"/g;
             s/\"start\": \"$BMC_RANGE_START_OLD\"/\"start\": \"$BMC_RANGE_START_NEW\"/g;
             s/\"end\": \"$BMC_RANGE_END_OLD\"/\"end\": \"$BMC_RANGE_END_NEW\"/g;
             s/\"start\": \"$BMC_VLAN_RANGE_START_OLD\"/\"start\": \"$BMC_VLAN_RANGE_START_NEW\"/g;
             s/\"end\": \"$BMC_VLAN_RANGE_END_OLD\"/\"end\": \"$BMC_VLAN_RANGE_END_NEW\"/g;" \
	databag.old/${net}_network.json > databag.new/${net}_network.json

	# not yet...
	knife data bag from file crowbar databag.new/${net}_network.json
done

#diff -u roles.old roles.new | less
#diff -u databag.old databag.new | less
