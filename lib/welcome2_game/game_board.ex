defmodule Welcome2Game.GameBoard do
  @behaviour Gex.GameBoard

  def default_state() do
    %Welcome2Game.StateObservation{
      g: Welcome2Game.Game.new_game()
    }
  end
end
