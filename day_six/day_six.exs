# TODO: Refactor!! While both parts one and two return the correct answer, the perfomance is just horrendous.
# solve_part_two completion took roughly 120.3 seconds.
# Potential solution ideas:
#   1. Attempt it with single dimension array?
#   2. Attempt it using an Agent to create mutable state variable to avoid having to loop through all 1mil points.
#     2a. In line with the point above, will attempt this puzzle with Golang to compare. Even aside from baked in perfomance, number of loops could be seriously reduced.
#   3. Also challenge here, aside from sheer volume, is that instructions need to be run sync to ensure correct state changes from begin to end.

defmodule DaySix do
  def read_file do
    result = File.read("./input.txt")

    case result do
      {:ok, content} -> content
      {:error, :enoent} -> IO.puts("error reading input file")
    end
  end

  def create_matrix do
    0..999
    |> Enum.to_list()
    |> Enum.map(fn _i ->
      Enum.to_list(0..999) |> Enum.map(fn _i -> 0 end)
    end)
  end

  def parse_coordinates(parts, pos) do
    parts
    |> Enum.at(pos)
    |> String.split(",")
    |> Enum.map(fn num_string ->
      case Integer.parse(num_string) do
        {num, _} -> num
        _ -> IO.puts("failed to parse string #{num_string}")
      end
    end)
    |> List.to_tuple()
  end

  def parse_instruction(instruction) do
    # turn on 489,959 through 759,964
    parts = String.split(instruction, " ")

    cond do
      String.contains?(instruction, "turn on") ->
        %{change: "turn on", start: parse_coordinates(parts, 2), end: parse_coordinates(parts, 4)}

      String.contains?(instruction, "turn off") ->
        %{
          change: "turn off",
          start: parse_coordinates(parts, 2),
          end: parse_coordinates(parts, 4)
        }

      String.contains?(instruction, "toggle") ->
        %{change: "toggle", start: parse_coordinates(parts, 1), end: parse_coordinates(parts, 3)}
    end
  end

  def handle_turn_on(parsed_instruction, matrix) do
    %{start: {start_x, start_y}, end: {end_x, end_y}} = parsed_instruction

    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {elem, j} ->
        if i in (start_y..end_y) && j in (start_x..end_x)  do
          1
        else
          elem
        end
      end)
    end)
  end

  def handle_turn_off(parsed_instruction, matrix) do
    %{start: {start_x, start_y}, end: {end_x, end_y}} = parsed_instruction
    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {elem, j} ->
        if i in (start_y..end_y) && j in (start_x..end_x)  do
          0
        else
          elem
        end
      end)
    end)
  end

  def handle_toggle(parsed_instruction, matrix) do
    %{start: {start_x, start_y}, end: {end_x, end_y}} = parsed_instruction
    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {elem, j} ->
        if i in (start_y..end_y) && j in (start_x..end_x)  do
          if elem === 1,
          do: 0,
          else: 1
        else
          elem
        end
      end)
    end)
  end

  # Answer is 569999
  def solve_part_one do
    read_file()
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(create_matrix(), fn instruction, matrix ->
      parsed_instruction = parse_instruction(instruction)

      case parsed_instruction do
        %{change: "turn on"} -> handle_turn_on(parsed_instruction, matrix)
        %{change: "turn off"} -> handle_turn_off(parsed_instruction, matrix)
        %{change: "toggle"} -> handle_toggle(parsed_instruction, matrix)
      end
    end)
    |> Enum.map(&Enum.sum(&1))
    |> Enum.sum()
    |> IO.inspect()
  end

  def handle_turn_on_two(parsed_instruction, matrix) do
    %{start: {start_x, start_y}, end: {end_x, end_y}} = parsed_instruction

    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {elem, j} ->
        if i in (start_y..end_y) && j in (start_x..end_x)  do
          elem + 1
        else
          elem
        end
      end)
    end)
  end

  def handle_turn_off_two(parsed_instruction, matrix) do
    %{start: {start_x, start_y}, end: {end_x, end_y}} = parsed_instruction
    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {elem, j} ->
        if i in (start_y..end_y) && j in (start_x..end_x)  do
          if elem === 0,
          do: elem,
          else: elem - 1
        else
          elem
        end
      end)
    end)
  end

  def handle_toggle_two(parsed_instruction, matrix) do
    %{start: {start_x, start_y}, end: {end_x, end_y}} = parsed_instruction
    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {elem, j} ->
        if i in (start_y..end_y) && j in (start_x..end_x)  do
          elem + 2
        else
          elem
        end
      end)
    end)
  end

  # Answer is 17836115
  def solve_part_two do
    read_file()
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(create_matrix(), fn instruction, matrix ->
      parsed_instruction = parse_instruction(instruction)

      case parsed_instruction do
        %{change: "turn on"} -> handle_turn_on_two(parsed_instruction, matrix)
        %{change: "turn off"} -> handle_turn_off_two(parsed_instruction, matrix)
        %{change: "toggle"} -> handle_toggle_two(parsed_instruction, matrix)
      end
    end)
    |> Enum.map(&Enum.sum(&1))
    |> Enum.sum()
    |> IO.inspect(label: "answer to part two:")
  end
end

defmodule Benchmark do
  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
    |> IO.inspect(label: "time to complete:")
  end
end

Benchmark.measure(fn  -> DaySix.solve_part_two() end)
