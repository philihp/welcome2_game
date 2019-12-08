defmodule Welcome2Game.MoveFinder do
  alias Welcome2Game.Card

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

  @poolable [
    a: 3,
    a: 7,
    a: 8,
    b: 1,
    b: 4,
    b: 8,
    c: 2,
    c: 7,
    c: 11
  ]

  def moves(%{state: :setup}) do
    [:start]
  end

  def moves(%{state: :playing, permit: nil}) do
    [{:permit, 0}, {:permit, 1}, {:permit, 2}]
  end

  def moves(%{state: :playing, permit: %Card{}, built: nil, player: player}) do
    for {row, index} <- @buildable, valid_build?(player, row, index) do
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

  def moves(%{state: :playing, permit: %Card{}, built: {_, _}}) do
    IO.puts("unknown permit")

    [:commit]
  end

  def moves(_state) do
    # e.g. state :gameover
    []
  end

  def valid_build?(_player, _row, index) do
    index < 4
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

  # [:poola3, :poola7, :poola8, :poolb1, :poolb4, :poolb8, :poolc2, :poolc7, :pool11]
end
