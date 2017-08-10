FROM ubuntu:latest
MAINTAINER Mike Wilson <geekinutah@gmail.com>

ENV TERM=xterm-256color

RUN add=apt=repository -y ppa:saltstack/salt \
  && apt-get -q update >/dev/null \
  && apt-get install -y software-properties-common dmidecode
  && apt-get install -y git curl subversion \
  && apt-get upgrade -y -o DPkg::Options::=--force-confold
  && mkdir -p /srv/salt/scripts \
  && mkdir -p /src/salt/reclass \
  && cd /srv/salt/scripts \
  && MASTER_HOSTNAME='hostname -f' salt-mastet-init.sh
  && source /srv/salt/scripts/salt-master-init.sh \
  && verify-salt-master \
  && verify-salt-minions \
  && /usr/bin/salt-master &\
  && salt-call salt.master \
  && salt-call salt.client \
  && salt-call state.apply salt,reclass,ntp --state-output=changes -lerror \
  && salt-call state.apply --state-output=changes -lerror \

  # Cleanup
  && apt-get clean autoclean \
  && apt-get autoremove --yes \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ 


VOLUME ["/srv/salt/reclass", "/etc/salt/pki"]

ENTRYPOINT ["start-salt-master.sh"]
