#! /usr/bin/fish

# Sets up the virtual interface ocean to communicate to-and-fro with containers

ip link add ocean link enp1s0 type macvlan mode bridge \
    && ip addr add 192.168.2.192 dev ocean \
    && ip link set ocean up \
    && ip route add 192.168.2.192/26 dev ocean