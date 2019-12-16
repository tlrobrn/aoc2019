defmodule AOC.Day14.Reaction do
  defstruct quantity: 0, product: nil, reactants: []

  def from_string(line) do
    [reactant_formulas, product_formula] = String.split(line, " => ", parts: 2, trim: true)

    reactants =
      reactant_formulas
      |> String.split(", ", trim: true)
      |> Enum.map(&parse_formula/1)

    {product, quantity} = parse_formula(product_formula)

    %__MODULE__{product: product, quantity: quantity, reactants: reactants}
  end

  @formula_pattern ~r/(\d+)\s+([A-Z]+)/

  defp parse_formula(formula) do
    [quantity, chemical] = Regex.run(@formula_pattern, formula, capture: :all_but_first)
    {chemical, String.to_integer(quantity)}
  end
end
