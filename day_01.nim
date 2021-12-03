import strutils, sequtils

let input = readFile("./input/day_01.txt").splitLines.filterIt(it.len > 0).map(parseInt)

proc sum(s: seq[int]): int =
  return s.foldl(a+b)

echo toSeq(0 .. input.len - 2).countIt input[it] < input[it+1]
echo toSeq(0 .. input.len - 4).countIt input[it..it+2].sum < input[it+1..it+3].sum
