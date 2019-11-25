defmodule Welcome2Game do
  alias Welcome2Game.Game
  defdelegate new_game(), to: Game
  defdelegate draw(state), to: Game
  defdelegate shuffle(state), to: Game
end
