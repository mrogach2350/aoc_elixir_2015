defmodule DayThreeUtils do
  @spec read_file() :: any()
  def read_file do
    result = File.read("./input.txt")

    case result do
      {:ok, content} -> content
      {:error, :enoent} -> IO.puts("error reading clue file")
    end
  end

  @spec create_visit([integer()], char()) :: [integer()]
  def create_visit(visits, dir) do
    visits
    |> List.first()
    |> Enum.with_index()
    |> Enum.map(fn {elem, idx} ->
      cond do
        dir === "<" and idx === 0 -> elem - 1
        dir === ">" and idx === 0 -> elem + 1
        dir === "^" and idx === 1 -> elem + 1
        dir === "v" and idx === 1 -> elem - 1
        true -> elem
      end
    end)
  end
end

# 2565
solve_part_one = fn ->
  DayThreeUtils.read_file()
  |> String.trim()
  |> String.split("")
  |> Enum.reduce([[0, 0]], fn dir, visits ->
    [DayThreeUtils.create_visit(visits, dir) | visits]
  end)
  |> MapSet.new()
  |> MapSet.size()
  |> IO.inspect()
end

# 2639
solve_part_two = fn ->
  DayThreeUtils.read_file()
  |> String.trim()
  |> String.split("")
  |> Enum.with_index()
  |> Enum.reduce({[[0, 0]], [[0, 0]]}, fn {dir, santa_idx}, {santa_visits, robo_visits} ->
    visits = if rem(santa_idx, 2) === 0, do: santa_visits, else: robo_visits

    if rem(santa_idx, 2) === 0,
      do: {[DayThreeUtils.create_visit(visits, dir) | santa_visits], robo_visits},
      else: {santa_visits, [DayThreeUtils.create_visit(visits, dir) | robo_visits]}
  end)
  |> Tuple.to_list()
  |> Enum.concat()
  |> MapSet.new()
  |> MapSet.size()
  |> IO.inspect()
end

solve_part_one.()
solve_part_two.()
