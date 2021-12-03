
import strscans

let input = "./input/day_02.txt"

type Position1 = tuple[horizontal: int, depth: int]
type Position2 = tuple[horizontal: int, depth: int, aim: int]

proc part1(input: string): int =
  var
    move: string
    units: int
    pos: Position1 = (0, 0)
  for line in input.lines:
    if scanf(line, "$w $i", move, units):
      if move == "forward":
        pos = (pos[0] + units, pos[1])
      if move == "up":
        pos = (pos[0], pos[1] - units)
      if move == "down":
        pos = (pos[0], pos[1] + units)
  return pos[0] * pos[1]


proc part2(input: string): int =
  var
    move: string
    units: int
    pos: Position2 = (0, 0, 0)
  for line in input.lines:
    if scanf(line, "$w $i", move, units):
      if move == "forward":
        pos = (pos[0] + units, pos[1] + (pos[2] * units), pos[2])
      if move == "up":
        pos = (pos[0], pos[1], pos[2] - units)
      if move == "down":
        pos = (pos[0], pos[1], pos[2] + units)
  return pos[0] * pos[1]

echo part1(input)
echo part2(input)
