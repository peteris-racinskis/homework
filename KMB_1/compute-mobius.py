#!/usr/bin/python3
import sys
INPUT_FILE="ieeja-ex2.txt"

# a smarter implementation might exist but this is at least polynomial
def compute_mobius_naive_cubic(ordering, n, output):
    for i in range(n):
        output[i][i] = 1
    for i in range(n): # every row
        for j in range(i): # columns up to diagonal
            for k in range(i): # all rows above (down to current)
                # ij - current row, column
                # kj - other row (above), current column
                # ik - current row (as row), other row (as column) in incidence matrix
                output[i][j] = output[i][j] - (output[k][j] if ordering[i][k] == 1 else 0)

def ascending_order(array: list, n):
    return sorted(array[1:], key=lambda x: x.index(1))

def transpose_and_clean(array, n):
    return [[array[j][i] for j in range(n)] for i in range(n)]

def print_array_line(line: list):
    output = ""
    for element in line:
        output = "{}{}\t".format(output, element)
    output = "[{}]".format(output)
    print(output)

def process_input(array):
    n = array[0][0]
    output = [[0] * n for _ in range(n)]
    array = ascending_order(array, n)
    transposed = transpose_and_clean(array, n)
    compute_mobius_naive_cubic(transposed, n, output)
    return output


if __name__ == "__main__":
    i, j = (int(x)-1 for x in sys.argv[1:])
    array = []
    with open(INPUT_FILE, mode="r") as f:
        [array.append(
            [int(y) for y in filter(lambda z: z.isdigit(), list(x))])
            for x in filter(lambda x: x[0] != "#", f.readlines())]
    output = process_input(array)
    [print_array_line(line) for line in output]
    print("[{},{}] {}".format(i+1, j+1, output[j][i])) #inverted because indices are easier to work with that way