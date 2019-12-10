defmodule Welcome2Game.Game do
  alias Welcome2Game.{Card, State, Tableau, MoveFinder}

  def new_game do
    deck =
      Welcome2Constants.deck()
      |> Poison.decode!(as: [%Card{}])
      |> Enum.shuffle()

    size = deck |> length |> div(3)

    %State{
      state: :playing,
      deck0: deck |> Enum.slice(0 * size, size),
      deck1: deck |> Enum.slice(1 * size, size),
      deck2: deck |> Enum.slice(2 * size, size),
      shown0: [],
      shown1: [],
      shown2: [],
      player: %Tableau{}
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

    %State{
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

    %State{
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

  def permit(state, number) do
    %State{
      state
      | permit: state |> Map.get(:"shown#{number}") |> hd,
        checkpoint: state.checkpoint || state,
        current_move: [{:permit, number} | state.current_move]
    }
  end

  def build(state, row, index) do
    %State{
      state
      | player: struct(state.player, %{:"row#{row}#{index}number" => state.permit.face}),
        built: {row, index},
        current_move: [{:build, row, index} | state.current_move]
    }
  end

  def pool(state, row, index) do
    effect = {:pool, row, index}

    %State{
      state
      | player: struct(state.player, %{:"row#{row}#{index}pool" => true}),
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def agent(state, size) do
    effect = {:agent, size}
    old_value = state.player |> Map.get(:"estate#{size}")
    new_value = size |> MoveFinder.next_estate(old_value)

    %State{
      state
      | player: struct(state.player, %{:"estate#{size}" => new_value}),
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def park(state, row) do
    effect = {:park, row}
    old_value = state.player |> Map.get(:"park#{row}")
    new_value = row |> MoveFinder.next_park(old_value)

    %State{
      state
      | player: struct(state.player, %{:"park#{row}" => new_value}),
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def fence(state, row, index) do
    effect = {:fence, row, index}

    %State{
      state
      | player: struct(state.player, %{:"fence#{row}#{index}" => true}),
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def bis(state, row, index, offset) do
    effect = {:bis, row, index, offset}

    %State{
      state
      | player:
          struct(state.player, %{
            :"row#{row}#{index}bis" => true,
            :"row#{row}#{index}number" =>
              Map.get(state.player, :"row#{row}#{index + offset}number")
          }),
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def temp(state, row, index, offset) do
    effect = {:temp, row, index, offset}

    %State{
      state
      | player: struct(state.player, %{:"row#{row}#{index}number" => state.permit.face + offset}),
        built: {row, index},
        effect: effect,
        current_move: [effect | state.current_move]
    }
  end

  def commit(state) do
    %State{
      state
      | permit: nil,
        built: nil,
        effect: nil,
        moves: state.current_move ++ [:commit] ++ state.moves,
        current_move: [],
        checkpoint: nil
    }
    |> draw
  end

  def rollback(state) do
    state.checkpoint
  end

  def view(state) do
    %{
      player: state.player |> Map.from_struct(),
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
      permit: state.permit,
      built: state.built,
      effect: state.effect,
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
