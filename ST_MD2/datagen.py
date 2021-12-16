def fac(x):
    fac = {1:1, 2:2, 3:6}
    return fac[x]

for z in range(1,4):
    print(f"z = {z}")
    for x in range(1,4):
        row = []
        for y in range(1,4):
            p1 = x * (x - fac(y) - 0.5)
            p2 = y * (y - fac(z))
            p3 = z * (z - fac(x))
            row.append((p1, p2, p3))
        s = " ".join([f"{i}\t" for i in row])
        print(s)
    
