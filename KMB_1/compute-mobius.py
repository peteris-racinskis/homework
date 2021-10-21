#!/usr/bin/python3
import sys
#INPUT_FILE="ieeja-ex1.txt" # change this to change input filename
#INPUT_FILE="ieeja-ex2.txt" # change this to change input filename
#INPUT_FILE="ieeja-ex3.txt" # change this to change input filename
INPUT_FILE="ieeja.txt" # change this to change input filename
PRINT_MATRICES=True
#PRINT_MATRICES=False

# a smarter implementation might exist but this is at least polynomial
# how this works: walks down the table computing from the "smallest" elements 
# first, then summing the already existing values for elements that are comparable
# ignores incomparable elements (subtracts 0)
def compute_mobius_cubic(zeta, n):
    incidence = transpose(zeta, n)
    output = [[0] * n for _ in range(n)]
    for i in range(n):
        output[i][i] = 1
    for i in range(n): # every row
        for j in range(i): # columns up to diagonal
            for k in range(i): # all rows above (down to current)
                # ij - current row, column
                # kj - other row (above), current column
                # ik - current row (as row), other row (as column) in incidence matrix
                output[i][j] = output[i][j] - (output[k][j] if incidence[i][k] == 1 else 0)
    return transpose(output, n)

def ascending_order(array: list, n):
    return sorted(array[1:], key=lambda x: x.index(1))

def transpose(array, n):
    return [[array[j][i] for j in range(n)] for i in range(n)]

def matmul(left, m, right, k, n):
    result = [[0] * k for _ in range(m)]
    for x in range(m):
        for y in range(k):
            result[x][y] = sum([left[x][z]*right[z][y] for z in range(n)])
    return result

def print_array_line(line: list):
    output = ""
    for element in line:
        output = "{}{}\t".format(output, element)
    output = "[{}]".format(output[:-1])
    print(output)

def print_results(zeta, mu, convolution):
    print("zeta(i,j)")
    [print_array_line(line) for line in zeta]
    print("mu(i,j)")
    [print_array_line(line) for line in mu]
    print("(zeta*mu)(i,j)")
    [print_array_line(line) for line in convolution]

def process_input(array):
    n = array[0][0]
    mu = [[0] * n for _ in range(n)]
    zeta = ascending_order(array, n)
    mu = compute_mobius_cubic(zeta, n)
    conv = matmul(zeta, n, mu, n, n)
    if PRINT_MATRICES:
        print_results(zeta, mu, conv)
    print()
    return mu


if __name__ == "__main__":
    i, j = (int(x)-1 for x in sys.argv[1:]) # minus 1 because mathematicians start indexing from 1
    array = []
    with open(INPUT_FILE, mode="r") as f:
        [array.append(
            [int(y) for y in filter(lambda z: z.isdigit(), list(x))])
            for x in filter(lambda x: x[0] != "#", f.readlines())]
    output = process_input(array)
    print("[{},{}] {}".format(i+1, j+1, output[i][j]))