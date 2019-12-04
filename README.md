# AOC

[Advent of Code 2019](https://adventofcode.com/2019)

## Mix Tasks

### Gen.Day

```sh
$ mix gen.day DAY
```

Generate modules and tests for the given day.
For example, when run for DAY 3, `$ mix gen.day 3` creates the following files.

```
lib/day3.ex
lib/day3/part1.ex
lib/day3/part2.ex
test/day3_test.exs
test/day3/part1_test.exs
test/day3/part2_test.exs
```

The input is expected to be put in `input/day3.txt`, and by default it is fed to the part modules' `run` function as lines.
If additional parsing is desired, a `parse` function may be defined in the `AOC.Day3` module to handle the lines.

### Star

```sh
$ mix star DAY PART
```

Run the puzzle for the given DAY and PART.
For example, to run day 5 part 2: `mix star 5 2`.
