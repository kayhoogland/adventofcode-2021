import strutils, strscans, sequtils, sets

type
  Coordinate = tuple[x: int, y: int]
  Fold = tuple[axis: char, i: int]

proc createDots(dotLines: seq[string]): HashSet[Coordinate] =
  var x, y: int
  for d in dotLines:
    if scanf(d, "$i,$i", x, y):
      result.incl((x, y))

proc createFolds(foldLines: seq[string]): seq[Fold] =
  var
    axis: char
    fold: int
  for d in foldLines:
    if scanf(d, "fold along $c=$i", axis, fold):
      result.add((axis, fold))

proc maxes(dots: HashSet[Coordinate]): (int, int) =
  result[0] = max(dots.mapIt(it.x))
  result[1] = max(dots.mapIt(it.y))

proc xFold(dots: HashSet[Coordinate], fold: int): HashSet[Coordinate] =
  result = dots
  let
    dots = toSeq(dots).filterIt(it.x > fold)
  for d in dots:
    result.excl(d)
    result.incl((fold - (d.x - fold), d.y))

proc yFold(dots: HashSet[Coordinate], fold: int): HashSet[Coordinate] =
  result = dots
  let
    dots = toSeq(dots).filterIt(it.y > fold)
  for d in dots:
    result.excl(d)
    result.incl((d.x, fold - (d.y - fold)))

proc fold(dots: HashSet[Coordinate], fold: Fold): HashSet[Coordinate] =
  if fold.axis == 'x':
    return dots.xFold(fold.i)
  if fold.axis == 'y':
    return dots.yFold(fold.i)

proc print(dots: HashSet[Coordinate]): void =
  let (maxX, maxY) = dots.maxes
  for y in 0..maxY:
    var line = ""
    for x in 0..maxX:
      if (x, y) in dots:
        line.add('x')
      else:
        line.add('_')
    echo line


proc solve(dotLines: seq[string], foldLines: seq[string]): int =
  var
    dots = createDots(dotLines)
    folds = createFolds(foldLines)

  for i, f in folds:
    dots = dots.fold(f)
    if i == 0:
      result = dots.len
  dots.print

let
  input = readFile("./input/day_13.txt").split("\n\n")
  dotLines = input[0].split("\n")
  foldLines = input[1].split("\n")

echo solve(dotLines, foldLines)
