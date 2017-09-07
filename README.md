# docker-reclass-salt-master
Simple container for reclass based salt-master

## Purpose

Spin up a simple salt master with your reclass model, it can then be connected to VMs, other containers, etc.

## Usage

Run like so:

    $ docker run -it --rm -v /home/username/git/my-model/:/srv/salt/reclass -v $SSH_AUTH_SOCK:/root/ssh-agent.sock -h cfg01.mydeploy.local geekinutah/reclass-salt-master

If you are connecting it to VMs, other containers, etc, you will need to consider adding docker networks. This is recommended, but left up to the user to figure out.

