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
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call(:shuffle, _from, src_state) do
    dst_state = Game.shuffle(src_state)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call({:permit, index}, _from, src_state) do
    dst_state = Game.permit(src_state, index)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call({:build, row, index}, _from, src_state) do
    dst_state = Game.build(src_state, row, index)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call(:pool, _from, src_state) do
    dst_state = Game.pool(src_state)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call({:agent, size}, _from, src_state) do
    dst_state = Game.agent(src_state, size)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call(:park, _from, src_state) do
    dst_state = Game.park(src_state)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call({:fence, row, index}, _from, src_state) do
    dst_state = Game.fence(src_state, row, index)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call({:bis, row, index, offset}, _from, src_state) do
    dst_state = Game.bis(src_state, row, index, offset)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call({:temp, row, index, offset}, _from, src_state) do
    dst_state = Game.temp(src_state, row, index, offset)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call(:commit, _from, src_state) do
    dst_state = Game.commit(src_state)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call(:rollback, _from, src_state) do
    dst_state = Game.rollback(src_state)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call(:identity, _from, src_state) do
    {:reply, Game.view(src_state), src_state}
  end
end
