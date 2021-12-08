import strutils, sequtils, tables, sets, std/algorithm

proc part1(input: string): int =
  var after = toSeq(input.lines).mapIt(it.split('|')[1].strip())
  for l in after:
    result += l.split(' ').countIt(it.len in @[2, 3, 4, 7])

proc countCommonChars(str: string, other: string): int =
  return (toHashSet(str) * toHashSet(other)).len

proc find(line: seq[string], length: int, number: string, count: int,
    table: Table[int, string]): string =
  var
    values = toSeq(table.values)
    line = line.filterIt(it notin values and it.len == length and
        number.countCommonChars(it) == count)

  assert line.len != 0
  return line[0]

proc determineNumbers(line: seq[string]): Table[int, string] =
  result[1] = line.filterIt(it.len == 2)[0]
  result[7] = line.filterIt(it.len == 3)[0]
  result[4] = line.filterIt(it.len == 4)[0]
  result[8] = line.filterIt(it.len == 7)[0]
  result[3] = find(line, 5, result[1], 2, result)
  result[9] = find(line, 6, result[3], 5, result)
  result[5] = find(line, 5, result[9], 5, result)
  result[2] = find(line, 5, result[9], 4, result)
  result[6] = find(line, 6, result[5], 5, result)
  result[0] = line.filterIt(it notin toSeq(result.values))[0]

proc sortValuesTable(table: Table[int, string]): Table[int, string] =
  for i in 0..9:
    var value = table[i]
    value.sort()
    result[i] = value

proc sortValuesSeq(s: seq[string]): seq[string] =
  for v in s:
    var value = v
    value.sort()
    result.add(value)

proc seqToInt(s: seq[int]): int =
  var str: string
  for v in s:
    str.add(intToStr(v))
  return parseInt(str)

proc part2(input: string): int =
  for l in input.lines:
    let
      before = l.split('|')[0].strip().split(' ')
      after = l.split('|')[1].strip().split(' ')
      table = determineNumbers(before).sortValuesTable
      invertedTable = toSeq(table.pairs).mapIt((it[1], it[0])).toTable
      seqOfInt = after.sortValuesSeq.mapIt(invertedTable[it])
    result += seqOfInt.seqtoInt

let input = "./input/day_08.txt"

echo part1(input)
echo part2(input)
