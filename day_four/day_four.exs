defmodule DayFour do
  # answer: iwrupvqb346386
  def solve_part_one(test_num \\ 1) do
    key = "iwrupvqb"

    if :crypto.hash(:md5, "#{key}#{test_num}")
       |> Base.encode16()
       |> String.starts_with?("00000"),
       do: IO.inspect(test_num, label: "Sucessful Number"),
       else: solve_part_one(test_num + 1)
  end

  def solve_part_two(test_num \\ 1) do
    key = "iwrupvqb"

    if :crypto.hash(:md5, "#{key}#{test_num}")
       |> Base.encode16()
       |> String.starts_with?("000000"),
       do: IO.inspect(test_num, label: "Sucessful Number"),
       else: solve_part_two(test_num + 1)
  end
end


DayFour.solve_part_two()
