#!/usr/bin/python3

fname = "mdt_gen.csv"
with open(fname, 'r') as f:
  s=f.readlines()
  
buf = []
for line in s[1:]:
  element = (line.split(","))
  l = []
  for x in element:
    x=x.replace("\n","")
    l.append(x)
  buf.append(l[:3])
  buf.append(l[3:])
[print(x) for x in buf]

ofname = "cleaned.csv"
with open(ofname,'w') as of:
  of.write("Depth,Dry,Wet\n")
  [print(",".join(x)) for x in buf]
  [of.write(",".join(x)+"\n") for x in buf]
  
