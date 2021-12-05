import strscans, sequtils, tables, std/algorithm


type
  Point = tuple[x: int, y: int]
  Line = tuple[kind: string, x1: int, y1: int, x2: int, y2: int, points: seq[Point]]


proc myCmp(x, y: Point): int =
  cmp(x.x, y.x)

proc findStraightPoints(x1: int, y1: int, x2: int, y2: int): seq[Point] =
  if x1 == x2:
    var low = min(y1, y2)
    var high = max(y1, y2)
    for i in low..high:
      result.add((x1, i))

  if y1 == y2:
    var low = min(x1, x2)
    var high = max(x1, x2)
    for i in low..high:
      result.add((i, y1))

proc findDiagonalPoints(x1: int, y1: int, x2: int, y2: int): seq[Point] =
  var points: seq[Point] = @[(x1, y1), (x2, y2)]
  points.sort(myCmp)
  for i, x in toSeq(points[0].x..points[1].x):
    if points[0].y > points[1].y:
      result.add((points[0].x+i, points[0].y-i))
    else:
      result.add((points[0].x+i, points[0].y+i))

proc parseLine(line: string): Line =
  var
    x1, y1, x2, y2: int
    kind: string
    points: seq[Point]
  if scanf(line, "$i,$i -> $i,$i", x1, y1, x2, y2):
    if x1 == x2 or y1 == y2:
      kind = "straight"
      points = findStraightPoints(x1, y1, x2, y2)
    else:
      kind = "diagonal"
      points = findDiagonalPoints(x1, y1, x2, y2)
    return (kind, x1, y1, x2, y2, points)

proc findOverlappingPoints(lines: seq[Line]): int =
  var table = initCountTable[Point]()
  for i, l in lines:
    for p in l.points:
      table.inc(p)
  for k, v in table.pairs:
    if v > 1:
      inc result

let
  input = "./input/day_05.txt"
  allLines = toSeq(input.lines).map(parseLine)
  straightLines = allLines.filterIt(it.kind == "straight")

echo findOverLappingPoints(straightLines)
echo findOverLappingPoints(allLines)
