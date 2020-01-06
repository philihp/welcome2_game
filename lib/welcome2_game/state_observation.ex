defmodule Welcome2Game.StateObservation do
  @behaviour Gex.StateObservation

  defstruct [
    :g,
    :ctx
  ]

  def reward(_state = %Welcome2Game.StateObservation{}) do
    0.0
  end

  def value(_state = %Welcome2Game.StateObservation{}) do
    0.0
  end

  def terminal?(_state = %Welcome2Game.StateObservation{}) do
    true
  end

  def winner(%Welcome2Game.StateObservation{g: %{winner: winner}}) do
    winner
  end

  def active_player(%Welcome2Game.StateObservation{}) do
    0
  end

  def advance(src_state, _move) do
    %Welcome2Game.StateObservation{
      g: src_state
    }
  end

  def actions(%Welcome2Game.StateObservation{}) do
    []
  end

  def feature_vector(%Welcome2Game.StateObservation{}) do
    [0.0, 0.0, 0.0]
  end
end
