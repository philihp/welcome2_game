defmodule Welcome2Game do
  def new_game do
    {:ok, state} = Supervisor.start_child(Welcome2Game.Supervisor, [])
    state
  end

  def draw(state) do
    GenServer.call(state, :draw)
  end

  def shuffle(state) do
    GenServer.call(state, :shuffle)
  end
end
