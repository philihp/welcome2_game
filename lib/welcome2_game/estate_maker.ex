defmodule Welcome2Game.EstateMaker do
  alias Welcome2Game.Tableau

  def a <|> b do
    Map.merge(a, b, fn _k, va, vb -> va + vb end)
  end

  def update(player = %Tableau{}) do
    %{
      1 => estates1,
      2 => estates2,
      3 => estates3,
      4 => estates4,
      5 => estates5,
      6 => estates6
    } =
      estates_from_player(player, :a)
      <|> estates_from_player(player, :b)
      <|> estates_from_player(player, :c)

    %Tableau{
      player
      | built_estates1: estates1,
        built_estates2: estates2,
        built_estates3: estates3,
        built_estates4: estates4,
        built_estates5: estates5,
        built_estates6: estates6
    }
  end

  def estates_from_player(player = %Tableau{}, which) do
    houses_per_row = %{
      a: 10,
      b: 11,
      c: 12
    }

    houses = player |> houses_from_player(which, houses_per_row[which]) |> Enum.reverse()
    fences = player |> fences_from_player(which, houses_per_row[which]) |> Enum.reverse()

    estates_from_row(houses, fences)
    |> Enum.map(&estate_sizer/1)
    |> Enum.reduce(%{}, fn estatesize, accum ->
      Map.update(accum, estatesize, 1, &(&1 + 1))
    end)
  end

  def estate_sizer(0) do
    0
  end

  def estate_sizer(power_of_ten) do
    length(Integer.digits(power_of_ten))
  end

  def estates_from_row([true], [true]) do
    [1]
  end

  def estates_from_row([false], [true]) do
    [0]
  end

  def estates_from_row([_], [false]) do
    []
  end

  def estates_from_row([true | houses], [true | fences]) do
    [1 | estates_from_row(houses, fences)]
  end

  def estates_from_row([false | houses], [true | fences]) do
    [0 | estates_from_row(houses, fences)]
  end

  def estates_from_row([true | houses], [false | fences]) do
    [following | trailing] = estates_from_row(houses, fences)
    [10 * following | trailing]
  end

  def estates_from_row([false | houses], [false | fences]) do
    [following | trailing] = estates_from_row(houses, fences)
    [0 * following | trailing]
  end

  def houses_from_player(_player, _which, 0) do
    []
  end

  def houses_from_player(player, which, curr) when curr >= 1 do
    [
      Map.get(player, :"row#{which}#{curr}number", :invalid) !== nil &&
        Map.get(player, :"row#{which}#{curr}plan", :invalid) === false
      | houses_from_player(player, which, curr - 1)
    ]
  end

  def fences_from_player(_player = %Tableau{}, _which, 0) do
    []
  end

  def fences_from_player(player = %Tableau{}, which, curr) when curr >= 0 do
    [
      Map.get(player, :"fence#{which}#{curr}", true)
      | fences_from_player(player, which, curr - 1)
    ]
  end
end
