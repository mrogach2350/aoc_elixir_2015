defmodule DayFive do
  def read_file do
    result = File.read("./input.txt")

    case result do
      {:ok, content} -> content
      {:error, :enoent} -> IO.puts("Error reading input file.")
    end
  end

  def is_nice_string(string) do
    # String needs to have two of the same letters touching, ie aa, bb, cc
    two_letter_touching =
      string
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce_while(false, fn {letter, idx}, _acc ->
        if letter === String.at(string, idx + 1),
          do: {:halt, true},
          else: {:cont, false}
      end)

    # At least three vowels, aeiou only
    num_of_vowels =
      string
      |> String.graphemes()
      |> Enum.reduce(0, fn letter, acc ->
        if String.contains?("aeiou", letter),
          do: acc + 1,
          else: acc
      end)

    # # Does not contain any of the following ab, cd, pq, or xy
    contains_naughty_pair = !String.contains?(string, ["ab", "cd", "pq", "xy"])

    contains_naughty_pair and num_of_vowels >= 3 and two_letter_touching
  end

  # Answer is 238
  def solve_part_one do
    read_file()
    |> String.trim()
    |> String.split("\n")
    |> Enum.filter(fn string -> is_nice_string(string) end)
    |> length()
    |> IO.inspect(label: "after filter")
  end

  # It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
  # It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.
  def is_nice_string_part_two do
  end

  def solve_part_two do
  end
end

DayFive.solve_part_one()
