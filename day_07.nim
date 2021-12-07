import strutils, sequtils, tables

let
  input = "./input/day_07.txt"
  crab = readFile(input).split(',').mapIt(parseInt(it.strip()))

proc fuelCost(dist: int): int =
  # Small math trick instead of looping
  return int(((1+dist)*dist)/2)

proc solve(crab: seq[int], part: int): int =
  var fuel = initTable[int, int]()

  for option in min(crab)..max(crab):
    fuel[option] = 0
    for c in crab:
      if part == 1:
        fuel[option] += abs(c-option)
      else:
        fuel[option] += fuelCost(abs(c-option))

  return toSeq(fuel.values).min

echo solve(crab, 1)
echo solve(crab, 2)
