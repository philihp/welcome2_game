defmodule Welcome2Game.Server do
  alias Welcome2Game.Game
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Game.new_game()}
  end

  def handle_call(:draw, _from, src_state) do
    dst_state = Game.draw(src_state)
    view = Game.view(dst_state)
    {:reply, view, dst_state}
  end

  def handle_call(:shuffle, _from, src_state) do
    dst_state = Game.shuffle(src_state)
    view = Game.view(dst_state)
    {:reply, view, dst_state}
  end
end
