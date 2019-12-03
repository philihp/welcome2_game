defmodule Welcome2Game.State do
  defstruct(
    state: :setup,
    winner: nil,
    moves: [],
    deck0: [],
    deck1: [],
    deck2: [],
    shown0: [],
    shown1: [],
    shown2: []
  )
end
