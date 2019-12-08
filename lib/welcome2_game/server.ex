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
    dst_state = src_state |> Game.draw()
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call(:shuffle, _from, src_state) do
    dst_state = src_state |> Game.shuffle()
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call({:permit, index}, _from, src_state) do
    dst_state = src_state |> Game.permit(index)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call({:build, row, index}, _from, src_state) do
    dst_state = src_state |> Game.build(row, index)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call({:pool, row, index}, _from, src_state) do
    dst_state = src_state |> Game.pool(row, index)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call({:bis, row, index, offset}, _from, src_state) do
    dst_state = src_state |> Game.bis(row, index, offset)
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call(:commit, _from, src_state) do
    dst_state = src_state |> Game.commit()
    {:reply, dst_state |> Game.view(), dst_state}
  end

  def handle_call(:identity, _from, src_state) do
    {:reply, src_state |> Game.view(), src_state}
  end
end
