import strutils, sequtils, tables, std/algorithm, sets

type
  Coordinate = tuple[x: int, y: int]
  Map = Table[Coordinate, int]

proc createMap(input: string): Map =
  for y, line in toSeq(input.lines):
    for x, number in line:
      result[(x, y)] = parseInt($number)

proc neighbors(c: Coordinate): seq[Coordinate] =
  return @[(c.x-1, c.y), (c.x+1, c.y), (c.x, c.y-1), (c.x, c.y+1)]

proc isLowPoint(c: Coordinate, map: Map): bool =
  result = true
  let value = map[c]
  for n in c.neighbors:
    if n in map and value >= map[n]:
      return false

proc lowPoints(map: Map): seq[Coordinate] =
  return toSeq(map.keys).filterIt(it.isLowPoint(map))

proc higherNeighbors(c: Coordinate, map: Map): seq[Coordinate] =
  return c.neighbors.filterIt(it in map and map[it] > map[c] and map[it] != 9)

proc bassin(c: Coordinate, map: Map): HashSet[Coordinate] =
  result.incl(c)
  for hn in c.higherNeighbors(map):
    result = result + hn.bassin(map)

proc part1(map: Map): int =
  for c in map.lowPoints:
    result += 1+map[c]

proc part2(map: Map): int =
  var sizes: seq[int] = @[]
  for c in map.lowPoints:
    sizes.add(c.bassin(map).len)
  return sorted(sizes, Descending)[0..2].foldl(a*b)

let
  input = "./input/day_09.txt"
  map = createMap(input)

echo part1(map)
echo part2(map)
