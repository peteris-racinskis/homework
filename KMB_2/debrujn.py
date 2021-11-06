#!/usr/bin/python3
# find euler cycle in graph of size n-1
# rather than hamilton cycle in size n
#
# Recursive function statements are avoided
# because python doesn't do tail call
# optimization.
#
import sys
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

def find_euler_cycle(graph: dict):
    partial_cycles = {vertex:[] for vertex in graph.keys()}
    for vertex, adj in graph.items():
        while len(adj) > 0:
            partial_cycles[vertex].append(get_cycle(graph, vertex))
    combined = []
    for vertex in partial_cycles.keys():
        for cycle in partial_cycles[vertex]:
            combined = combined + cycle
    return combined

def get_cycle(graph: dict, vertex: str):
    cycle = []
    last_vertex = vertex
    next_vertex = ""
    while next_vertex != vertex:
        next_vertex = graph[last_vertex].pop()
        edge = last_concat(last_vertex, next_vertex)
        cycle.append(edge)
        last_vertex = next_vertex
    return cycle

def last_concat(s1: str, s2: str):
    return s1 + s2[-1]

def debrujn_sequence(cycle: list):
    result = ""
    for edge in cycle:
        result = last_concat(result, edge)
    return result

def debrujn_test(sequence: str, n: int, m: int):
    print(sequence)
    if m < 2:
        print("Trivial sequence")
        return
    original = len(sequence)
    sequence = sequence + sequence[:n-1]
    already_seen = []
    for i in range(original):
        substr = sequence[i:i+n]
        if substr in already_seen:
            print("Invalid: {} appears twice".format(substr))
            return
        already_seen.append(substr)
    print("all ok, {} unique sequential substrings:".format(len(already_seen)))
    print(already_seen)

def find_debrujn(m, n):
    if n < 2:
        return "".join([str(x) for x in range(m)])
    if m < 2:
        return "".join([str(0)] * n)
    return debrujn_sequence(find_euler_cycle(create_graph(m,n)))

if __name__ == "__main__":
    with open(INFILE, 'r') as f:
        cont = f.readlines()
        m, n  = int(cont[0]), int(cont[1])
    result = find_debrujn(m, n)
    with open(OUTFILE, 'w') as f:
        f.write(result)
    if PRINT:
        debrujn_test(result, n, m)