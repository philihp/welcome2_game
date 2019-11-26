defmodule Welcome2Game do
  # defdelegate new_game(), to: Game
  def new_game do
    {:ok, state} = Supervisor.start_child(Welcome2Game.Supervisor, [])
    state
  end

  # defdelegate draw(state), to: Game
  def draw(state) do
    GenServer.call(state, :draw)
  end

  # defdelegate shuffle(state), to: Game
  def shuffle(state) do
    GenServer.call(state, :shuffle)
  end
end
