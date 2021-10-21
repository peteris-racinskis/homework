## How to use

Option 1: Execute script directly (Unix systems only, needs execution privileges, shebang might need correcting to your Python path)

```
$ chmod u+x compute-mobius.py
$ ./compute-mobius.py 1 2
> [1,2] -1
```

Option 2: provide a Python executable:

```
$ python3 compute-mobius.py 1 2
> [1,2] -1
```

Changing input file path: comment/uncomment lines for the included examples or add your own for the INPUT_FILE variable

```
#INPUT_FILE="ieeja-ex1.txt" 
#INPUT_FILE="ieeja-ex2.txt" 
#INPUT_FILE="ieeja-ex3.txt" 
INPUT_FILE="ieeja.txt" 
```

To print the Mobius function in matrix form mu(i,j), change the lines

```
#PRINT_MATRICES=True
PRINT_MATRICES=False
```
to

```
PRINT_MATRICES=True
#PRINT_MATRICES=False
```
Output example:

```
$ ./compute-mobius.py 1 2 
zeta(i,j)
[1      1       1       1       1       1]
[0      1       1       0       0       1]
[0      0       1       0       0       1]
[0      0       0       1       0       1]
[0      0       0       0       1       1]
[0      0       0       0       0       1]
mu(i,j)
[1      -1      0       -1      -1      2]
[0      1       -1      0       0       0]
[0      0       1       0       0       -1]
[0      0       0       1       0       -1]
[0      0       0       0       1       -1]
[0      0       0       0       0       1]
(zeta*mu)(i,j)
[1      0       0       0       0       0]
[0      1       0       0       0       0]
[0      0       1       0       0       0]
[0      0       0       1       0       0]
[0      0       0       0       1       0]
[0      0       0       0       0       1]

[1,2] -1
```