defmodule Mix.Tasks.Star do
  use Mix.Task

  @shortdoc "Run a DAY and PART"

  def run([day, part]) do
    result =
      [Elixir, :AOC, "Day#{day}"]
      |> Module.concat()
      |> apply(:"part#{part}", [])

    IO.puts("Day #{day}, Part #{part}: #{result}")
  end
end
