import sequtils, tables, strutils

type
  Coordinate = tuple[x: int, y: int]
  Octopus = tuple[level: int, flashed: bool, neighbors: seq[Coordinate]]
  Map = OrderedTable[Coordinate, Octopus]

proc inMap(c: Coordinate): bool =
  if c.x notin 0..9 or c.y notin 0..9:
    return false
  return true

proc neighbors(c: Coordinate): seq[Coordinate] =
  return @[(c.x-1, c.y), (c.x+1, c.y), (c.x, c.y-1), (c.x, c.y+1),
           (c.x-1, c.y-1), (c.x-1, c.y+1), (c.x+1, c.y-1), (c.x+1,
               c.y+1)].filter(inMap)

proc createMap(input: string): Map =
  for y, line in toSeq(input.lines):
    for x, number in line:
      result[(x, y)] = (parseInt($number), false, (x, y).neighbors)

proc resetFlash(map: Map): Map =
  result = map
  for k, v in map.pairs:
    if v.flashed:
      result[k] = (0, false, k.neighbors)

proc updateNeighBors(c: Coordinate, map: Map): Map =
  result = map
  result[c] = (0, true, c.neighbors)
  for n in c.neighbors:
    let o = map[n]
    if o.level notin @[0, 10]:
      result[n] = (o.level+1, false, o.neighbors)

proc findTen(map: Map): seq[Coordinate] =
  return toSeq(map.keys).filterIt(map[it].level == 10)

proc performStep(map: Map): Map =
  for k, v in map.pairs:
    result[k] = (v.level+1, false, v.neighbors)
  while true:
    let toFlash = result.findTen
    if toFlash.len == 0:
      break
    for c in toFlash:
      result = c.updateNeighbors(result)

proc printMap(map: Map): string =
  for y in 0..9:
    var printer: seq[string]
    for x in 0..9:
      let level = map[(x, y)].level
      if level == 10:
        printer.add("x")
      else:
        printer.add($level)
    echo printer.join("")

proc solve(map: Map): (int, int) =
  var
    map = map
    step = 1
    flashCount = 0
  while true:
    map = map.performStep
    flashCount += toSeq(map.values).filterIt(it.flashed).len
    if step == 100:
      result[0] = flashCount
    if toSeq(map.values).filterIt(it.flashed).len == 100:
      result[1] = step
      break
    map = map.resetFlash
    inc step

let
  input = "./input/day_11.txt"
  map = createMap(input)

echo solve(map)
