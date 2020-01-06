defmodule Welcome2Game.State do
  @behaviour Gex.StateObservation

  alias Welcome2Game.{State, Tableau}

  defstruct(
    state: :setup,
    winner: nil,
    moves: [],
    history: [],
    current_move: [],
    checkpoint: nil,
    plan1: nil,
    plan2: nil,
    plan3: nil,
    plan1_used: false,
    plan2_used: false,
    plan3_used: false,
    deck1: [],
    deck2: [],
    deck3: [],
    shown1: [],
    shown2: [],
    shown3: [],
    permit: nil,
    built: nil,
    effect: nil,
    player: %Tableau{}
  )

  def reward(_state = %State{}) do
    # TODO
    0.0
  end

  def value(_state = %State{}) do
    # TODO
    0.0
  end

  def terminal?(%State{winner: winner}) do
    winner != nil
  end

  def winner(%State{winner: winner}) do
    winner
  end

  def active_player(%State{}) do
    0
  end

  def advance(src_state, _move) do
    src_state
  end

  def actions(%State{moves: actions}) do
    actions
  end

  def feature_vector(%State{}) do
    [0.0, 0.0, 0.0]
  end
end
