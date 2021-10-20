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

To print the Mobius function in matrix form mu(i,j), uncomment the line

```
#[print_array_line(line) for line in output] 
```

Output example (i -> row, j -> column):

```
$ ./compute-mobius.py 1 2
> [1	0	0	0	0	0]
> [-1	1	0	0	0	0]
> [0	-1	1	0	0	0]
> [-1	0	0	1	0	0]
> [-1	0	0	0	1	0]
> [2	0	-1	-1	-1	1]
> [1,2] -1
```