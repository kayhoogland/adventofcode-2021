import strutils, strscans, tables, sequtils

type Edges = Table[string, seq[string]]

proc createEdges(input: string): Edges =
  for l in input.lines:
    var node1, node2: string
    if scanf(l, "$w-$w", node1, node2):
      if result.hasKeyOrPut(node1, @[node2]):
        result[node1].add(node2)

      if result.hasKeyOrPut(node2, @[node1]):
        result[node2].add(node1)

proc isLower(s: string): bool =
  return any(s, proc (c: char): bool = c.isLowerAscii())

proc canVisit(edges: Edges, visited: CountTable[string], small_caves: seq[
    string], node: string): bool =
  if node notin small_caves or node notin visited:
    return true

  return small_caves.filterIt(visited[it] > 1).len == 0

proc part1(edges: Edges, visited: CountTable[string] = initCountTable[string](),
    start: string = "start"): int =
  if start == "end":
    return 1

  var visited = visited
  if start notin visited:
    if start.isLower:
      visited.inc(start)
    for neighbour in edges[start]:
      result += part1(edges, visited, neighbour)

proc part2(edges: Edges, visited: CountTable[string] = initCountTable[string](),
    small_caves: seq[string], start: string = "start"): int =
  if start == "end":
    return 1
  if start == "start" and start in visited:
    return 0

  var visited = visited
  if edges.canVisit(visited, small_caves, start):
    if start in small_caves:
      visited.inc(start)
    for neighbour in edges[start]:
      result += part2(edges, visited, small_caves, neighbour)

let
  input = "./input/day_12.txt"
  edges = input.createEdges
  small_caves = toSeq(edges.keys).filterIt(it.isLower)

echo edges.part1
echo edges.part2(small_caves = small_caves)
