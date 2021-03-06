FROM ubuntu:latest
MAINTAINER Mike Wilson <geekinutah@gmail.com>

ENV TERM=xterm-256color

RUN apt-get -q update >/dev/null
RUN apt-get install -y software-properties-common dmidecode wget psmisc
RUN wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
RUN echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main" > /etc/apt/sources.list.d/saltstack.list
RUN apt-get -q update >/dev/null
RUN apt-get install -y git curl subversion
RUN apt-get upgrade -y -o DPkg::Options::=--force-confold
RUN mkdir -p /srv/salt/scripts /etc/salt/pki/minion /srv/salt/reclass

# Cleanup
RUN apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/ 

ADD start-salt-master.sh /usr/local/bin/start-salt-master.sh
RUN chmod +x /usr/local/bin/start-salt-master.sh

EXPOSE 4505 4506 443
VOLUME ["/srv/salt/reclass/", "/etc/salt/pki/", "/root/ssh-agent.sock"]

ENTRYPOINT ["/usr/local/bin/start-salt-master.sh"]
