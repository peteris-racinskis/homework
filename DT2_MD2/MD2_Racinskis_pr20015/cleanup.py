#!/usr/bin/python3
import sys
import re


def clean(ifname, ofname):
    with open(ifname, 'r') as f:
        buf = f.read()
    buf = re.sub(r'(\n)\s*r', r'\1*', buf)
    # remove the stupid *>i syntax from older files
    buf = re.sub(r'(\*[\s>])i',r'\1 ',buf)
    # Concatenate ipv6 lines
    buf = re.sub(r'\n\s+([0-9a-z]|:)',r'\t\t\1',buf)
    with open(ofname, 'w') as of:
        of.write(buf)


if __name__ == "__main__":
    try:
        fnames = sys.argv[1:]
    except IndexError:
        print("Provide filenames!")
    for fname in fnames:
        ofname = "/".join(fname.split("/")[:-1]) + "/c_" + fname.split("/")[-1]
        print("Working on file: {} Output: {}".format(fname,ofname))
        clean(fname, ofname)

