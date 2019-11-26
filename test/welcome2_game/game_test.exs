defmodule Welcome2Game.GameTest do
  alias Welcome2Game.Game
  use ExUnit.Case

  test "new_game returns a game" do
    game = Game.new_game()
    assert length(game.deck0) === 27
    assert length(game.deck1) === 27
    assert length(game.deck2) === 27
    assert game.shown0 === []
    assert game.shown1 === []
    assert game.shown2 === []
  end

  test "draw pulls from deck0" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.deck0 |> length == (game1.deck0 |> length) + 1
  end

  test "draw puts into shown0" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.shown0 |> length == (game1.shown0 |> length) - 1
  end

  test "draw pulls from deck1" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.deck1 |> length == (game1.deck1 |> length) + 1
  end

  test "draw puts into shown1" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.shown1 |> length == (game1.shown1 |> length) - 1
  end

  test "draw pulls from deck2" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.deck2 |> length == (game1.deck2 |> length) + 1
  end

  test "draw puts into shown2" do
    game0 = Game.new_game()
    game1 = game0 |> Game.draw()
    assert game0.shown2 |> length == (game1.shown2 |> length) - 1
  end

  test "shuffle regenerates the game" do
    game = Game.new_game() |> Game.draw() |> Game.shuffle()
    assert length(game.deck0) === 27
    assert length(game.deck1) === 27
    assert length(game.deck2) === 27
    assert game.shown0 === []
    assert game.shown1 === []
    assert game.shown2 === []
  end
end
