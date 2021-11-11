from debruijn import *

if __name__ == "__main__":
    for m in range(10):
        for n in range(5):
            print("m = {}, n = {}".format(m,n))
            result = find_debruijn(m, n)
            debruijn_test(result, n, m)