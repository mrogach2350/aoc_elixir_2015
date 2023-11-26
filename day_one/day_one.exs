# defmodule Counter do
#   use Agent

#   def start_link(initial_value) do
#     Agent.start_link(fn -> initial_value end, name: __MODULE__)
#   end

#   def value do
#     Agent.get(__MODULE__, & &1)
#   end

#   def increment do
#     Agent.update(__MODULE__, &(&1 + 1))
#   end

#   def decrement do
#     Agent.update(__MODULE__, &(&1 - 1))
#   end
# end

readFile = fn () ->
  result = File.read("./day_one.txt")

  case result do
    {:ok, content} -> content
    {:error, :enoent} -> IO.puts("error reading clue file")
  end
end

# solvePartOne = fn () ->
#   content = readFile.()

#   lefts = content |> String.graphemes() |> Enum.count(fn x -> x == "(" end)
#   rights = content |> String.graphemes() |> Enum.count(fn x -> x == ")" end)

#   IO.puts(lefts - rights)
#  end

betterSolvePartOne = fn () ->
  content = readFile.()
  result = content
    |> String.graphemes()
    |> Enum.reduce(0, fn char, acc ->
      case char do
        "(" -> acc + 1
        ")" -> acc - 1
      end
    end)

    IO.puts("solvePartOne: #{result}")
end

# solvePartTwo = fn () ->
#   Counter.start_link(0)
#   content = readFile.()


#   # 1783
#   result = content
#   |> String.graphemes()
#   |> Enum.with_index()
#   |> Enum.each(fn elem ->
#     case elem do
#       {"(", _idx} -> Counter.increment()
#       {")", _idx} -> Counter.decrement()
#     end

#     if Counter.value() === -1 do
#       {_char, idx} = elem
#       IO.puts(idx)
#     end
#    end)

# end

betterSolvePartTwo = fn () ->
  content = readFile.()

  # 1783
  result = content
  |> String.graphemes()
  |> Enum.with_index()
  |> Enum.reduce_while(0, fn {char, idx}, acc ->
    cond do
      acc === -1 -> {:halt, idx}
      char === "(" -> {:cont, acc + 1}
      char === ")" -> {:cont, acc - 1}
    end
  end)

  IO.puts("solvePartTwo: #{result}")
end

betterSolvePartOne.()
betterSolvePartTwo.()
