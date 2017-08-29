#!/bin/bash

STORAGE_RANGE_END_OLD='10.76.6.126'
STORAGE_RANGE_END_NEW='10.76.6.191'

ROLE_NAME_SUFFIX='virtual_cloud_suse_de'


# Adjusting Roles
mkdir roles.old roles.new
for role in network-config-default $(knife role list | grep $ROLE_NAME_SUFFIX); do

	knife role show -F json $role > roles.old/$role.json

    sed "s/\"end\": \"$STORAGE_RANGE_END_OLD\"/\"end\": \"$STORAGE_RANGE_END_NEW\"/g;" \
        roles.old/$role.json > roles.new/$role.json

	# not yet...
	#knife role from file roles.new/$role.json
done


# Adjusting Data Bags
mkdir databag.old databag.new
for net in storage; do

	knife data bag show -F json crowbar ${net}_network > databag.old/${net}_network.json

    sed "s/\"end\": \"$STORAGE_RANGE_END_OLD\"/\"end\": \"$STORAGE_RANGE_END_NEW\"/g;" \
	    databag.old/${net}_network.json > databag.new/${net}_network.json

	# not yet...
	#knife data bag from file crowbar databag.new/${net}_network.json
done

#diff -u roles.old roles.new | less
#diff -u databag.old databag.new | less

# Adjusting network proposal
crowbarctl proposal show --json network default > proposal_network_old.json

sed "s/\"end\": \"$STORAGE_RANGE_END_OLD\"/\"end\": \"$STORAGE_RANGE_END_NEW\"/g;" \
    proposal_network_old.json > proposal_network_new.json

#diff -u proposal_network_old.json proposal_network_new.json | less
#crowbarctl proposal edit --file=proposal_network_new.json network default


# Adjusting network.json
sed "s/\"end\": \"$STORAGE_RANGE_END_OLD\"/\"end\": \"$STORAGE_RANGE_END_NEW\"/g;" \
/etc/crowbar/network.json > /etc/crowbar/network_new.json

#diff -Nuri /etc/crowbar/network.json /etc/crowbar/network_new.json
#mv /etc/crowbar/network_new.json /etc/crowbar/network.json
