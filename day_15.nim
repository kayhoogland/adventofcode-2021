import sets, tables, strutils, heapqueue

type Point = tuple[x: int, y: int]

proc neighbors(c: Point): seq[Point] =
  return @[(c.x-1, c.y), (c.x+1, c.y), (c.x, c.y-1), (c.x, c.y+1)]

proc dijkstra(points: Table[Point, int], target: Point, start: Point = (0, 0),
    risk: int = 0): int =
  var
    minRisk = {start: risk}.toTable
    newRisk: int
    point: Point
    queue = [(risk, start)].toHeapQueue
    risk = risk
    visited = [start].toHashSet

  while queue.len != 0:
    (risk, point) = queue.pop()
    if point == target: return risk

    for neighb in point.neighbors:
      if neighb notin points or neighb in visited: continue
      visited.incl(neighb)
      newRisk = risk + points[neighb]
      if newRisk < minRisk.getOrDefault(neighb, 999999):
        minRisk[neighb] = newRisk
        queue.push((newRisk, neighb))

proc createPoints(input: seq[string]): Table[Point, int] =
  for y in 0..<input.len:
    for x, val in input[y]:
      result[(x, y)] = parseInt($val)

proc expandPoints(points: Table[Point, int], n, len_x, len_y: int): Table[Point, int] =
  result = points
  for y in 0..<n:
    for x in 0..<n:
      if x == 0 and y == 0: continue
      for k, v in points.pairs:
        var value = (v + x + y)
        if value >= 10:
          value = value mod 9
        result[(k.x + x * len_x, k.y + y * len_y)] = value

let
  input = readFile("./input/day_15.txt").strip().splitLines
  len_x = input[0].len
  len_y = input.len
  points = createPoints(input)

echo dijkstra(points, (99, 99))
echo dijkstra(points.expandPoints(5, len_x, len_y), (499, 499))
