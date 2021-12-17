import strscans, sets, math

type
  Area = tuple[x1, x2, y1, y2: int]
  Pos = tuple[x, y: int]
  Velocity = tuple[x, y: int]

proc inArea(pos: Pos, area: Area): bool =
  result = true
  if (pos.x < area.x1 or pos.x > area.x2 or pos.y < area.y1 or pos.y > area.y2):
    return false

proc step(pos: Pos, vel: Velocity): tuple[pos: Pos, vel: Velocity] =
  result[0] = (pos.x + vel.x, pos.y + vel.y)
  result[1] = (max(vel.x - 1, 0), vel.y - 1)

proc minXSpeed(area: Area): int =
  return int(sqrt(float(area.x1*2)))

proc solve(area: Area): (int, int) =
  var
    speeds: OrderedSet[Velocity]
  for x in area.minXSpeed..area.x2:
    for y in area.y1..abs(area.y1):
      var
        pos: Pos = (0, 0)
        starting_vel = (x, y)
        vel = starting_vel
        max_y = 0
      while true:
        (pos, vel) = pos.step(vel)
        max_y = if pos.y > max_y: pos.y else: max_y
        if pos.inArea(area):
          speeds.incl(starting_vel)
          if max_y > result[0]:
            result[0] = max_y
            break
        elif pos.y < area.y1 or pos.x > area.x2:
          break
  result[1] = speeds.len

let input = readFile("./input/day_17.txt")
var
  x1, x2, y1, y2: int
  area: Area

if scanf(input, "target area: x=$i..$i, y=$i..$i", x1, x2, y1, y2):
  area = (x1, x2, y1, y2)

echo solve(area)
