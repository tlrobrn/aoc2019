defmodule AOC.Day14.Part1 do
  alias AOC.Day14.Reaction

  def run(reactions) do
    gather_requirements(
      reactions,
      initial_requirements(reactions),
      %{"ORE" => 0}
    )
  end

  defp gather_requirements(_, [], gathered), do: Map.get(gathered, "ORE")
  defp gather_requirements(reactions, [{"ORE", desired_quantity} | needed], gathered) do
    gather_requirements(reactions, needed, Map.update(gathered, "ORE", desired_quantity, &(&1 + desired_quantity)))
  end
  defp gather_requirements(reactions, [{product, desired_quantity} | needed], gathered) do
    quantity_from_prior_reactions = Map.get(gathered, product, 0)
    case desired_quantity - quantity_from_prior_reactions do
      0 ->
        gather_requirements(reactions, needed, Map.put(gathered, product, 0))
      q when q > 0 ->
        %Reaction{quantity: reacted_quantity, reactants: reactants} = Map.get(reactions, product)
        repetitions = ceil(q / reacted_quantity)
        total_quantity = reacted_quantity * repetitions
        new_requirements = Enum.map(reactants, fn {reactant, reactant_quantity} ->
          {reactant, reactant_quantity * repetitions}
        end)
        gather_requirements(reactions, needed ++ new_requirements, Map.put(gathered, product, total_quantity - q))
      q ->
        gather_requirements(reactions, needed, Map.put(gathered, product, -q))
    end
  end

  defp initial_requirements(reactions) do
    %Reaction{reactants: reactants} = Map.get(reactions, "FUEL")
    reactants
  end
end
