from debruijn import *

if __name__ == "__main__":
    for m in range(1,10):
        for n in range(1,5):
            result = find_debruijn(m, n)
            debruijn_test(result, n, m)