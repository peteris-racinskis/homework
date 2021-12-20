#!/usr/bin/python3

def fac(x):
    return {1:1, 2:2, 3:6}[x]

def pareto_dominated(x, y):
    bigger = False
    smaller = False
    for i in range(len(x)):
        if x[i] < y[i]:
            bigger = True
        elif x[i] > y[i]:
            smaller = True
    return bigger and not smaller

def pareto_top(x_list, y):
    for x in x_list:
        if pareto_dominated(y[0], x[0]):
            print(f"Outcome {y[0]} dominated by {x[0]}")
            return False
    return True

if __name__ == "__main__":
    frame = []
    cells = []
    for z in range(1,4):
        print(f"z = {z}")
        matrix = []
        for x in range(1,4):
            row = []
            for y in range(1,4):
                p1 = x * (x - fac(y) - 0.5) 
                p2 = y * (y - fac(z))
                p3 = z * (z - fac(x))
                row.append((p1, p2, p3))
                cells.append([(p1, p2, p3), (x,y,z)])
            s = " ".join([f"{i}\t" for i in row])
            matrix.append(row)
            print(s)
        frame.append(matrix)
    print()
    print("Pareto optima")
    top = []
    for cell in cells:
        if pareto_top(cells, cell):
            top.append(cell)
    print(f"Maximal ({len(top)} outcomes):")
    [print(f"{t[0]} \tat {t[1]}") for t in top]