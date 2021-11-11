#!/usr/bin/python3
# find euler cycle in graph of size n-1
# rather than hamilton cycle in size n
#
# Recursive function statements are avoided
# because python doesn't do tail call
# optimization.
#
INFILE = "ieeja.txt"
OUTFILE = "izeja.txt"
PRINT = True

def create_graph(m, n):
    vertices = [str(x) for x in range(m)]
    while len(vertices[0]) < n-1:
        vertices = vertex_build_layer(m, vertices)
    return {vertex:adjacent_list(vertex, m) for vertex in vertices}

def vertex_build_layer(m: int, previous):
    result = []
    for line in previous:
        result = result + [line + str(x) for x in range(m)]
    return result

def adjacent_list(vertex: str, m: int):
    return [vertex[1:] + str(x) for x in range(m)]

def find_euler(graph: dict):
    partial_cycles = {vertex:[] for vertex in graph.keys()}
    # find cycles from each vertex
    for vertex, adj in graph.items():
        while len(adj) > 0:
            partial_cycles[vertex].append(get_cycle_vert(graph, vertex))
    # combine cycles from each vertex
    for vertex in partial_cycles.keys():
        if len(partial_cycles[vertex]) > 0:
            combined = partial_cycles[vertex].pop()
            for cycle in partial_cycles[vertex]:
                combined = combined[:-1] + cycle
            partial_cycles[vertex] = combined
    # splice all cycles into the longest
    longest = []
    for path in partial_cycles.values():
        longest = path if len(path) > len(longest) else longest
    while len(longest) < len(graph.values()):
        for i in range(len(longest)):
            vertex = longest[i]
            if len(partial_cycles[vertex]) > 0:
                longest = longest[:i] + partial_cycles[vertex].pop() + longest[i+1:]
    return longest

def get_cycle_vert(graph: dict, vertex: str):
    cycle = [vertex]
    next_vertex = ""
    while next_vertex != vertex:
        next_vertex = graph[cycle[-1]].pop()
        cycle.append(next_vertex)
    return cycle

def last_concat(s1: str, s2: str):
    return s1 + s2[-1]

def debruijn_sequence(cycle: list):
    result = ""
    for vertex in cycle[:-1]:
        result = last_concat(result, vertex)
    return result

def debrujn_test(sequence: str, n: int, m: int, print_seq = False):
    print("m = {}, n = {}".format(m,n))
    if m < 2:
        print("Trivial sequence")
        return
    original = len(sequence)
    sequence = sequence + sequence[:n-1]
    if print_seq:
        print(sequence)
    already_seen = []
    for i in range(original):
        substr = sequence[i:i+n]
        if substr in already_seen:
            print("Invalid: {} appears twice".format(substr))
            return
        already_seen.append(substr)
    print("all ok, {} unique sequential substrings:".format(len(already_seen)))
    if print_seq:
        print(already_seen)

def find_debruijn(m, n):
    if n < 2:
        return "".join([str(x) for x in range(m)])
    if m < 2:
        return "".join([str(0)] * n)
    return debruijn_sequence(find_euler(create_graph(m,n)))

if __name__ == "__main__":
    with open(INFILE, 'r') as f:
        cont = f.readlines()
        m, n  = int(cont[0]), int(cont[1])
    result = find_debruijn(m, n)
    with open(OUTFILE, 'w') as f:
        f.write(result)
    if PRINT:
        debrujn_test(result, n, m, True)