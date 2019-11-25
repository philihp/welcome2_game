defmodule Welcome2Game.Game do
  defstruct(
    deck0: [],
    deck1: [],
    deck2: [],
    shown0: [],
    shown1: [],
    shown2: []
  )

  def new_game do
    deck = Welcome2Constants.deck() |> Enum.shuffle()
    len = deck |> length
    size = div(len, 3)

    %Welcome2Game.Game{
      deck0: deck |> Enum.slice(0 * size, size),
      deck1: deck |> Enum.slice(1 * size, size),
      deck2: deck |> Enum.slice(2 * size, size),
      shown0: [],
      shown1: [],
      shown2: []
    }
  end

  def draw(state) do
    %{
      deck0: [drawn_card0 | remainder_deck0],
      deck1: [drawn_card1 | remainder_deck1],
      deck2: [drawn_card2 | remainder_deck2],
      shown0: shown0,
      shown1: shown1,
      shown2: shown2
    } = state

    %Welcome2Game.Game{
      deck0: remainder_deck0,
      deck1: remainder_deck1,
      deck2: remainder_deck2,
      shown0: [drawn_card0 | shown0],
      shown1: [drawn_card1 | shown1],
      shown2: [drawn_card2 | shown2]
    }
  end

  def shuffle(state) do
    deck =
      (state.deck0 ++ state.shown0 ++ state.deck1 ++ state.shown1 ++ state.deck2 ++ state.shown2)
      |> Enum.shuffle()

    len = deck |> length
    size = div(len, 3)

    %Welcome2Game.Game{
      deck0: deck |> Enum.slice(0 * size, size),
      deck1: deck |> Enum.slice(1 * size, size),
      deck2: deck |> Enum.slice(2 * size, size),
      shown0: [],
      shown1: [],
      shown2: []
    }
  end
end
