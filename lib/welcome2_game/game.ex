defmodule Welcome2Game.Game do
  def new_game do
    deck =
      Welcome2Constants.deck()
      |> Poison.decode!(as: [%Card{}])
      |> Enum.shuffle()

    size = deck |> length |> div(3)

    %Welcome2Game.State{
      state: :playing,
      deck0: deck |> Enum.slice(0 * size, size),
      deck1: deck |> Enum.slice(1 * size, size),
      deck2: deck |> Enum.slice(2 * size, size),
      shown0: [],
      shown1: [],
      shown2: [],
      player0: [
        %Tableau{}
      ]
    }
    |> draw
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

    %Welcome2Game.State{
      state
      | deck0: remainder_deck0,
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

    %Welcome2Game.State{
      state
      | deck0: deck |> Enum.slice(0 * size, size),
        deck1: deck |> Enum.slice(1 * size, size),
        deck2: deck |> Enum.slice(2 * size, size),
        shown0: [],
        shown1: [],
        shown2: []
    }
    |> draw
  end

  def view(state) do
    %{
      deck0_suit: state.deck0 |> top |> Map.get(:suit),
      deck1_suit: state.deck1 |> top |> Map.get(:suit),
      deck2_suit: state.deck2 |> top |> Map.get(:suit),
      deck0_length: state.deck0 |> length,
      deck1_length: state.deck1 |> length,
      deck2_length: state.deck2 |> length,
      shown0: state.shown0 |> top,
      shown1: state.shown1 |> top,
      shown2: state.shown2 |> top,
      state: state.state,
      moves: MoveFinder.moves(state)
    }
  end

  defp top([]) do
    nil
  end

  defp top(list) do
    list |> hd
  end
end
