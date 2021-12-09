import strutils, sequtils, tables, std/algorithm, sets

type Coordinate = tuple[x: int, y: int]

proc createMap(input: string): Table[Coordinate, int] =
  for y, line in toSeq(input.lines):
    for x, number in line:
      result[(x, y)] = parseInt($number)

proc neighbors(c: Coordinate): seq[Coordinate] =
  return @[(c.x-1, c.y), (c.x+1, c.y), (c.x, c.y-1), (c.x, c.y+1)]

proc isLowPoint(c: Coordinate, map: Table[Coordinate, int], keys: seq[
    Coordinate]): bool =
  result = true
  let value = map[c]
  for n in c.neighbors:
    if n in keys and value >= map[n]:
      return false

proc lowPoints(map: Table[Coordinate, int], keys: seq[Coordinate]): seq[Coordinate] =
  return keys.filterIt(it.isLowPoint(map, keys))

proc higherNeighbors(c: Coordinate, map: Table[Coordinate, int], keys: seq[
    Coordinate]): seq[Coordinate] =
  return c.neighbors.filterIt(it in keys and map[it] > map[c] and map[it] != 9)

proc bassin(c: Coordinate, map: Table[Coordinate, int], keys: seq[
    Coordinate]): HashSet[Coordinate] =
  let higher_neighbors = c.higherNeighbors(map, keys)
  result.incl(c)
  if higher_neighbors.len > 0:
    for hn in higher_neighbors:
      result = result + hn.bassin(map, keys)

proc part1(map: Table[Coordinate, int], keys: seq[Coordinate]): int =
  for c in map.lowPoints(keys):
    result += 1+map[c]

proc part2(map: Table[Coordinate, int], keys: seq[Coordinate]): int =
  var sizes: seq[int] = @[]
  for c in map.lowPoints(keys):
    sizes.add(c.bassin(map, keys).len)
  return sorted(sizes, Descending)[0..2].foldl(a*b)

let
  input = "./input/day_09.txt"
  map = createMap(input)
  keys = toSeq(map.keys)

echo part1(map, keys)
echo part2(map, keys)
