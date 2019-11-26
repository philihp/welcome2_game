defmodule Welcome2Game.Server do
  alias Welcome2Game.Game
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Game.new_game()}
  end

  def handle_call(:draw, _from, game) do
    game = Game.draw(game)
    {:reply, game, game}
  end

  def handle_call(:shuffle, _from, game) do
    game = Game.shuffle(game)
    {:reply, game, game}
  end
end
