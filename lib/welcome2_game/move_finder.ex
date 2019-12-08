defmodule Welcome2Game.MoveFinder do
  alias Welcome2Game.Card

  @per_row [a: 10, b: 11, c: 12]

  @buildable [
    a: 1,
    a: 2,
    a: 3,
    a: 4,
    a: 5,
    a: 6,
    a: 7,
    a: 8,
    a: 9,
    a: 10,
    b: 1,
    b: 2,
    b: 3,
    b: 4,
    b: 5,
    b: 6,
    b: 7,
    b: 8,
    b: 9,
    b: 10,
    b: 11,
    c: 1,
    c: 2,
    c: 3,
    c: 4,
    c: 5,
    c: 6,
    c: 7,
    c: 8,
    c: 9,
    c: 10,
    c: 11,
    c: 12
  ]

  @estates %{
    1 => %{1 => 3},
    2 => %{2 => 3, 3 => 5},
    3 => %{3 => 4, 4 => 5, 5 => 7},
    4 => %{4 => 5, 5 => 6, 6 => 7, 7 => 9},
    5 => %{5 => 6, 6 => 7, 7 => 8, 8 => 10},
    6 => %{6 => 7, 7 => 8, 8 => 19, 10 => 12}
  }

  # TODO gross refactor
  def next_estate(current, size) do
    @estates[size][current]
  end

  def moves(%{state: :setup}) do
    [:start]
  end

  def moves(%{state: :playing, permit: nil}) do
    [{:permit, 0}, {:permit, 1}, {:permit, 2}]
  end

  def moves(%{state: :playing, permit: %Card{face: number}, built: nil, player: player}) do
    for {row, index} <- @buildable, valid_build?(player, row, index, number) do
      {:build, row, index}
    end
  end

  def moves(%{
        state: :playing,
        permit: %Card{suit: "pool-manufacturer"},
        built: {row, index},
        effect: nil,
        player: player
      }) do
    [:commit] ++
      cond do
        valid_pool?(player, row, index) ->
          [{:pool, row, index}]

        true ->
          []
      end
  end

  def moves(%{
        state: :playing,
        permit: %Card{suit: "bis"},
        built: {_, _},
        effect: nil,
        player: player
      }) do
    [:commit] ++
      for {row, index} <- @buildable,
          offset <- [-1, 1],
          valid_bis?(player, row, index, offset) do
        {:bis, row, index, offset}
      end
  end

  def moves(%{
        state: :playing,
        permit: %Card{suit: "real-estate-agent"},
        built: {_, _},
        effect: nil,
        player: player
      }) do
    [:commit] ++
      for {size, steps} <- @estates,
          valid_agent?(player, size, steps) do
        {:agent, size}
      end
  end

  def moves(%{state: :playing, permit: %Card{}, built: {_, _}}) do
    IO.puts("unknown permit")

    [:commit]
  end

  def moves(_state) do
    # e.g. state :gameover
    []
  end

  def valid_build?(player, row, index, number) do
    unoccupied = fn x -> x != 0 end
    is_lower = fn x -> x < number end
    is_higher = fn x -> x > number end
    house_number = fn i -> Map.get(player, :"row#{row}#{i}number", 0) end

    Enum.all?([
      house_number.(index) === 0,
      1..index
      |> Enum.map(house_number)
      |> Enum.filter(unoccupied)
      |> Enum.all?(is_lower),
      index..@per_row[row]
      |> Enum.map(house_number)
      |> Enum.filter(unoccupied)
      |> Enum.all?(is_higher)
    ])
  end

  def valid_pool?(player, row, index) do
    !(Map.get(player, :"row#{row}#{index}pool", :invalid) in [true, :invalid])
  end

  def valid_bis?(player, row, index, offset) do
    existing = Map.get(player, :"row#{row}#{index + offset}number", :invalid)
    newbuild = Map.get(player, :"row#{row}#{index}number", :invalid)

    # TODO: make sure there's no fence between the two

    cond do
      # existing offset build is not a real index
      existing == :invalid -> false
      # existing build has not been built
      existing == 0 -> false
      # new build is not a real index
      newbuild == :invalid -> false
      # new build has already been built
      newbuild != 0 -> false
      true -> true
    end
  end

  def valid_agent?(player, size, steps) do
    Map.has_key?(steps, Map.get(player, :"estate#{size}"))
  end

  # [:poola3, :poola7, :poola8, :poolb1, :poolb4, :poolb8, :poolc2, :poolc7, :pool11]
end
