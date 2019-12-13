defmodule Welcome2Game.State do
  alias Welcome2Game.Tableau

  defstruct(
    state: :setup,
    winner: nil,
    moves: [],
    history: [],
    current_move: [],
    checkpoint: nil,
    plan0: nil,
    plan1: nil,
    plan2: nil,
    plan0_used: false,
    plan1_used: false,
    plan2_used: false,
    deck0: [],
    deck1: [],
    deck2: [],
    shown0: [],
    shown1: [],
    shown2: [],
    permit: nil,
    built: nil,
    effect: nil,
    player: %Tableau{}
  )
end
