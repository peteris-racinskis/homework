#!/usr/bin/python3

import sys

def intrange(iterable):
    #return ["{0:04x} // dec: {0:06d}\tbin: {0:016b}\n".format(x) for x in iterable]
    return ["{0:04x}\n".format(x) for x in iterable]

def zeros(size):
    return intrange([0 for x in range(size)])

def sequence(size):
    return intrange([x for x in range(size)])

def squares(size):
    return intrange([x**2 for x in range(size)])

def random(size):
    return []


def dispatch(comm, size, fname):
    cb = {
        "zeros":zeros,
        "squares":squares,
        "random":random,
        "count":sequence
    }
    buf = cb[comm](size)
    with open(fname,'w') as f:
        [f.write(x) for x in buf]


if __name__ == "__main__":
    print(sys.argv[1:])
    command,length,resname = sys.argv[1:] 
    dispatch(command,int(length),resname)


