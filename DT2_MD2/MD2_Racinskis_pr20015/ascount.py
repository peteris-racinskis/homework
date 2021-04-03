#!/usr/bin/python3 -u
import sys
import re


def count_ASNS(nets):
    asn_counts = {}
    for net in nets:
        if len(net) > 0 and len(net[1]) > 0:
            asn = net[1][-1]
        else:
            asn = 0
        if asn not in asn_counts:
            asn_counts[asn] = 1
        else:
            asn_counts[asn] = asn_counts[asn] + 1
    return (len(asn_counts),
            sorted(asn_counts.items(),key=lambda item: -item[1])[:10])

def longest_paths(nets):
    return sorted(nets, key=lambda item: -len(item[1]))[:10]

def parse(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    nets = []
    net = ""
    ipv4_sub = r'([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}'
    ipv6_sub = r'([0-9a-z]{0,4}:{1,2}){1,4}\/[0-9]{1,2}'
    for line in lines:
        words = line.split()
        if "0" not in words or len(words) < 2:
            continue
        if re.match(ipv6_sub,words[1]) or re.match(ipv4_sub,words[1]):
            net = words[1]
        if words[0] == "*>":
            path = list(dict.fromkeys(words[words.index("0")+1:-1]))
            nets.append((net,path))
    return nets


if __name__ == "__main__":
    try:
        fnames = sys.argv[1:]
    except IndexError:
        print("Provide a filename!")
    for fname in fnames:
        print("##########\n##########\nFile: {}".format(fname))
        nets = parse(fname)
        num_asns, asns = count_ASNS(nets)
        paths = longest_paths(nets)
        print("Total number of unique final AS: {}".format(num_asns))
        print("Most common ASNs:")
        for a in asns:
            print("ASN: {}\tCount: {}".format(a[0],a[1]))
        print("Longest AS paths:")
        for p in paths:
            print("Subnet: {0:<20}\tPath length: {1}\tFinal AS: {2}"
                    .format(p[0],len(p[1]),p[1][-1]))

