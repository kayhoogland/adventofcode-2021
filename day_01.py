with open("input/day_01.txt") as f:
    numbers = f.readlines()

numbers = [int(i) for i in numbers]

count = 0
for i, n in enumerate(numbers):
    if sum(numbers[i : i + 3]) < sum(numbers[i+1 : i + 4]):
        count += 1

print(count)
