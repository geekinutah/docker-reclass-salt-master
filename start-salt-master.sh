#!/bin/bash -x
if `grep -q alldone /root/everythingisread`; then
  exec /usr/bin/salt-master --log-level=error
else
  svn export --force https://github.com/salt-formulas/salt-formulas-scripts/trunk /srv/salt/scripts
  cd /srv/salt/scripts
  MASTER_HOSTNAME=`hostname -f` /srv/salt/scripts/salt-master-init.sh
  SSH_AUTH_SOCK='/root/ssh-agent.sock' # TODO: This is kinda scary
  source /srv/salt/scripts/salt-master-init.sh
  verify-salt-master
  verify-salt-minions
  salt-call state.apply salt,reclass,ntp --state-output=changes -lerror
  salt-call state.apply --state-output=changes -lerror
  /usr/bin/killall salt-master
  echo 'alldone' > /root/everythingisready
  exec /usr/bin/salt-master --log-level=error
fi
