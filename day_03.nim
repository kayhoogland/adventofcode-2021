import tables, sequtils, strutils

proc createTable(inputSeq: seq[string]): Table[int, seq[char]] =
  var table = initTable[int, seq[char]]()
  for line in inputSeq:
    for i in 0..<line.len:
      if i notin table:
        table[i] = @[]
      table[i].add(line[i])
  return table

proc calcMostCommon(chars: seq[char], favor: char): tuple[most: char, least: char] =
  var zero, one: int
  zero = countIt(chars, it == '0')
  one = countIt(chars, it == '1')
  if zero > one:
    return ('0', '1')
  elif one > zero:
    return ('1', '0')
  else:
    return ('1', '0')

proc dropOnChar(input: seq[string], c: char, col: int): seq[string] =
  result = @[]
  for l in input:
    if l[col] == c:
      result.add(l)


proc part1(inputSeq: seq[string]): int =
  var gamma, epsilon: string
  var table = createTable(inputSeq)
  for i in 0..<toSeq(table.keys).len:
    var t = table[i].calcMostCommon('1')
    gamma.add(t.most)
    epsilon.add(t.least)

  return parseBinInt(gamma) * parseBinInt(epsilon)

proc generator(inputSeq: seq[string]): string =
  var inputSeq = inputSeq
  var table = createTable(inputSeq)
  for i in 0..<toSeq(table.keys).len:
    var t = table[i].calcMostCommon('1')
    inputSeq = inputSeq.dropOnChar(t.most, i)
    table = createTable(inputSeq)
    if inputSeq.len == 1:
      return inputSeq[0]

proc scrubber(inputSeq: seq[string]): string =
  var inputSeq = inputSeq
  var table = createTable(inputSeq)
  for i in 0..<toSeq(table.keys).len:
    var t = table[i].calcMostCommon('0')
    inputSeq = inputSeq.dropOnChar(t.least, i)
    table = createTable(inputSeq)
    if inputSeq.len == 1:
      return inputSeq[0]


proc part2(inputSeq: seq[string]): int =
  var
    generator = generator(inputSeq)
    scrubber = scrubber(inputSeq)
  return parseBinInt(generator) * parseBinInt(scrubber)


proc solve(input: string): (int, int) =
  var inputSeq = toSeq(input.lines)
  result[0] = part1(inputSeq)
  result[1] = part2(inputSeq)



let input = "./input/day_03.txt"

echo solve(input)
