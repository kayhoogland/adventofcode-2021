import strutils, sequtils, tables

proc solve(fish: seq[int], days: int): int =
  var
    fish = fish
    table = initCountTable[int]()
    new_day = initCountTable[int]()

  for f in fish: table.inc(f)

  for d in 1..days:
    for k in 0..8: new_day[k] = 0
    for k in 0..8:
      if k == 0:
        new_day[8] = table[0]
        new_day[6] = table[0]
      else:
        new_day[k-1] = table[k] + new_day[k-1]

    table = new_day

  for k in 0..8: result += new_day[k]

let
  input = "./input/day_06.txt"
  fish = readFile(input).split(',').mapIt(parseInt(it.strip()))

echo solve(fish, 80)
echo solve(fish, 256)
