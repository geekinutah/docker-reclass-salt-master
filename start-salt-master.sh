cd /srv/salt/scripts
MASTER_HOSTNAME='hostname -f' salt-master-init.sh
source /srv/salt/scripts/salt-master-init.sh
verify-salt-master
verify-salt-minions
/usr/bin/salt-master &
salt-call salt.master
salt-call salt.client
salt-call state.apply salt,reclass,ntp --state-output=changes -lerror
salt-call state.apply --state-output=changes -lerror
killall salt-master
#run salt master now!!
