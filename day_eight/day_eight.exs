defmodule DayEight do
  def read_file do
    case File.read("./input.txt") do
      {:ok, content} -> content
      {:error, } -> IO.puts("error reading file")
    end
  end

  def solve_part_one do
    test_string = read_file()
      |> String.trim()
      |> String.split("\n")
      |> Enum.at(0)

    test_string
      |> String.split("")
      |> Enum.map(fn elem ->
        cond do
          is_bitstring(elem) -> IO.puts("#{elem} is bitstring")
          true -> IO.puts("#{elem} is not bitstring")
        end
      end)

      # test_string
      # |> String.graphemes()
      # |> IO.inspect(label: "test_string graphemes")
  end
end

DayEight.solve_part_one()
