import strutils, sequtils, tables

type Card = tuple[cols: Table[int, seq[int]], rows: Table[int, seq[int]]]

proc parseRows(card: string): Table[int, seq[int]] =
  let rows = card.split("\n").filterIt(it.len > 0)
  for i in 0..<rows.len:
    result[i] = rows[i].split(' ').filterIt(it.len > 0).map(parseInt)

proc parseCols(card: string): Table[int, seq[int]] =
  let rows = card.split("\n").filterIt(it.len > 0)

  for r in rows:
    let rowValues = r.split(' ').filterIt(it.len > 0).map(parseInt)
    for i in 0..<rowValues.len:
      if i notin result:
        result[i] = @[]
      result[i].add(int(rowValues[i]))

proc parseCards(card: string): Card =
  result.rows = card.parseRows
  result.cols = card.parseCols

proc calcScore(card: Card, drawnNumbers: seq[int]): int =
  var x = 0
  let y = drawnNumbers[^1]
  for c in card.cols.values:
    let s = c.filterIt(it notin drawnNumbers)
    if s.len > 0: x += s.foldl(a+b)
  return x * y

proc checkBingo(card: Card, drawnNumbers: seq[int]): int =
  for c in card.cols.values:
    if c.filterIt(it notin drawnNumbers).len == 0:
      return card.calcScore(drawnNumbers)
  for r in card.rows.values:
    if r.filterIt(it notin drawnNumbers).len == 0:
      return card.calcScore(drawnNumbers)
  return 0

proc part1(allNumbers: seq[int], cards: seq[Card]): int =
  var drawnNumbers: seq[int] = @[]
  for i in allNumbers:
    drawnNumbers.add(i)
    for c in cards:
      let score = c.checkBingo(drawnNumbers)
      if score > 0:
        return score

proc part2(allNumbers: seq[int], cards: seq[Card]): int =
  var
    drawnNumbers: seq[int] = @[]
    skipCards: seq[int] = @[]
  for n in allNumbers:
    drawnNumbers.add(n)
    for i, c in cards:
      if i in skipCards: continue
      let score = c.checkBingo(drawnNumbers)
      if score > 0:
        skipCards.add(i)
      if cards.len == skipCards.len:
        return cards[skipCards[^1]].calcScore(drawnNumbers)


let
  input = readFile("./input/day_04.txt").split("\n\n")
  allNumbers = input[0].split(',').map(parseInt)
  cards = input[1..^1].map(parseCards).filterIt(it.rows.len > 0)


echo part1(allNumbers, cards)
echo part2(allNumbers, cards)
