#!/bin/bash -x
svn export --force https://github.com/salt-formulas/salt-formulas/trunk/deploy/scripts /srv/salt/scripts
cd /srv/salt/scripts
MASTER_HOSTNAME=`hostname -f` /srv/salt/scripts/salt-master-init.sh
SSH_AUTH_SOCK='/root/ssh-agent.sock' # TODO: This is kinda scary
. /srv/salt/scripts/salt-master-init.sh
verify-salt-master
verify-salt-minions
/usr/bin/salt-master &
salt-call salt.master
salt-call salt.client
salt-call state.apply salt,reclass,ntp --state-output=changes -lerror
salt-call state.apply --state-output=changes -lerror
/usr/bin/killall salt-master
exec /usr/bin/salt-master --log-level=all
