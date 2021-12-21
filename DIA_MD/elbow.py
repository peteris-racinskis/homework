#!/usr/bin/python3
import sys
IFILE=sys.argv[1]

def curve(x1, x2, x3):
    prev = x2-x1
    nex = x3-x2
    return prev / nex

def curve_max(x_list):
    max = 0
    amax = 0
    for i in range(1, len(x_list)-1) :
        x1, x2, x3 = x_list[i-1:i+2]
        c = curve(x1, x2, x3)
        if i > 1 and not c > max:
            break
        amax = (i,x2) if c > max else amax
        max = c if c > max else max
        print(f"x = {x2} curve = {c}")
    print(f"max = {max}")
    print(f"amax = {amax}")

with open(IFILE, 'r') as f:
    xlist = [float(x) for x in f.readlines()]
curve_max(xlist)