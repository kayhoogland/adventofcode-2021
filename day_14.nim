import strutils, tables, strscans, strformat

type Mapper = Table[string, char]

proc createMapper(map_lines: seq[string]): Mapper =
  var
    key: string
    value: char
  for l in map_lines:
    if scanf(l, "$w -> $c", key, value):
      result[key] = value

proc pairCounts(s: string): CountTable[string] =
  for i in 0..<s.len-1:
    result.inc(s[i..i+1])

proc answer(char_counts: CountTableRef[char]): int =
  return char_counts.largest.val - char_counts.smallest.val

proc solve(s: string, mapper: Mapper): (int, int) =
  var
    char_counts = newCountTable(s)
    pair_counts = s.pairCounts

  for i in 1..40:
    var new_pair_counts = initCountTable[string]()
    for k, v in pair_counts.pairs:
      if k in mapper:
        let
          value_to_add = mapper[k]
          new_key1 = &"{k[0]}{value_to_add}"
          new_key2 = &"{value_to_add}{k[1]}"
        new_pair_counts.inc(new_key1, v)
        new_pair_counts.inc(new_key2, v)
        char_counts.inc(value_to_add, v)

    pair_counts = new_pair_counts

    if i == 10:
      result[0] = char_counts.answer

  result[1] = char_counts.answer

let
  input = readFile("./input/day_14.txt").split("\n\n")
  initial_string = input[0]
  mapper = input[1].split("\n").createMapper

echo solve(initial_string, mapper)
