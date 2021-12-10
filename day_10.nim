import strutils, sequtils, tables, std/deques, std/algorithm, math

type
  PointTable = Table[char, int]
  LineInfo = tuple[bad: bool, c: char, brackets: Deque[char]]
  MatchingTable = Table[char, char]

proc isBadLine(line: string, invert_table: MatchingTable): LineInfo =
  var brackets: Deque[char]
  for element in line:
    if element in ['(', '[', '{', '<']:
      brackets.addLast(element)
    else:
      if brackets.peekLast() != invert_table[element]:
        return (true, element, brackets)
      else:
        brackets.popLast
  return (false, 'x', brackets)

proc part1(input: string, points: PointTable,
    invert_table: MatchingTable): int =
  for l in input.lines:
    let (bad, c, _) = l.isBadLine(invert_table)
    if bad: result += points[c]

proc part2(input: string, points: PointTable, closing_to_opening: MatchingTable,
    opening_to_closing: MatchingTable): int =
  var
    lineScore = initTable[int, int]()
    correctLines = toSeq(input.lines).mapIt(it.isBadLine(
        closing_to_opening)).filterIt(not it.bad)

  for index, l in correctLines:
    var (_, _, brackets) = l
    lineScore[index] = 0
    while brackets.len != 0:
      lineScore[index] *= 5
      lineScore[index] += points[opening_to_closing[brackets.popLast]]

  let
    sortedValues = sorted(toSeq(lineScore.values))
    middleIndex = int(floor(sortedValues.len / 2))
  return sortedValues[middleIndex]

let
  input = "./input/day_10.txt"
  point_table_part_1 = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
  point_table_part_2 = {')': 1, ']': 2, '}': 3, '>': 4}.toTable
  closing_to_opening = {')': '(', ']': '[', '>': '<', '}': '{'}.toTable
  opening_to_closing = toSeq(closing_to_opening.pairs).mapIt((it[1], it[0])).toTable


echo part1(input, point_table_part_1, closing_to_opening)
echo part2(input, point_table_part_2, closing_to_opening, opening_to_closing)
