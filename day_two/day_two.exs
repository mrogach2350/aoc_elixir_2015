readFile = fn ->
  result = File.read("./input.txt")

  case result do
    {:ok, content} -> content
    {:error, :enoent} -> IO.puts("error reading clue file")
  end
end

# 1586300
solvePartOne = fn ->
  readFile.()
  |> String.trim()
  |> String.split("\n")
  |> Enum.reduce(0, fn box, acc ->
    [a, b, c] =
      String.split(box, "x")
      |> Enum.map(fn side ->
        case Integer.parse(side) do
          {int, _} -> int
          _ -> IO.inspect(side)
        end
      end)

    sides = [a * b, a * c, b * c]
    doubledSides = Enum.map(sides, fn side -> side * 2 end)
    total_area_for_box = [Enum.min(sides) | doubledSides] |> Enum.sum()
    acc + total_area_for_box
  end)
  |> IO.puts()
end

# 3737498
solvePartTwo = fn ->
  readFile.()
  |> String.trim()
  |> String.split("\n")
  |> Enum.reduce(0, fn box, acc ->
    [a, b, c] =
      String.split(box, "x")
      |> Enum.map(fn side ->
        case Integer.parse(side) do
          {int, _} -> int
          _ -> IO.inspect(side)
        end
      end)
      |> Enum.sort()

    perimiter = Enum.reduce([a, b], 0, fn x, acc -> acc + x * 2 end)
    area = Enum.product([a, b, c])
    acc + perimiter + area
  end)
  |> IO.puts()
end

solvePartOne.()
solvePartTwo.()
