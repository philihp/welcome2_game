defmodule Welcome2Game.GameTest do
  alias Welcome2Game.{Game, Tableau}
  use ExUnit.Case

  test "new_game returns a game" do
    game = Game.new_game()
    assert length(game.deck0) === 26
    assert length(game.deck1) === 26
    assert length(game.deck2) === 26
    assert length(game.shown0) === 1
    assert length(game.shown1) === 1
    assert length(game.shown2) === 1
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
    assert length(game.deck0) === 26
    assert length(game.deck1) === 26
    assert length(game.deck2) === 26
    assert length(game.shown0) === 1
    assert length(game.shown1) === 1
    assert length(game.shown2) === 1
  end

  describe "#houses_from_player" do
    test "does it" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        fencea3: true,
        rowa5number: 4,
        fencea5: true
      }

      assert Game.houses_from_player(player, :a, 10) ===
               Enum.reverse([
                 true,
                 true,
                 true,
                 false,
                 true,
                 false,
                 false,
                 false,
                 false,
                 false
               ])
    end
  end

  describe "#fences_from_player" do
    test "does it" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        fencea3: true,
        rowa5number: 4,
        fencea5: true
      }

      assert Game.fences_from_player(player, :a, 10) ===
               Enum.reverse([
                 false,
                 false,
                 true,
                 false,
                 true,
                 false,
                 false,
                 false,
                 false,
                 true
               ])
    end
  end

  describe "#estates_from_player" do
    test "does it" do
      player = %Tableau{
        rowa1number: 1,
        rowa2number: 2,
        rowa3number: 3,
        fencea3: true,
        rowa5number: 4,
        fencea5: true
      }

      assert Game.estates_from_player(player, :a) == %{
               0 => 2,
               3 => 1
             }
    end
  end

  describe "#estates_from_row" do
    test "|house|" do
      assert Game.estates_from_row(
               [true],
               [true]
             ) == [1]
    end

    test "|vacnt|" do
      assert Game.estates_from_row(
               [false],
               [true]
             ) == [0]
    end

    test "|house house|" do
      assert Game.estates_from_row(
               [true, true],
               [false, true]
             ) == [10]
    end

    test "|house vacnt|" do
      assert Game.estates_from_row(
               [true, false],
               [false, true]
             ) == [0]
    end

    test "|vacnt house|" do
      assert Game.estates_from_row(
               [false, true],
               [false, true]
             ) == [0]
    end

    test "|house house house|" do
      assert Game.estates_from_row(
               [true, true, true],
               [false, false, true]
             ) == [100]
    end

    test "|house vacnt|house|" do
      assert Game.estates_from_row(
               [true, false, true],
               [false, true, true]
             ) == [0, 1]
    end

    test "|house|house|" do
      assert Game.estates_from_row(
               [true, true],
               [true, true]
             ) == [1, 1]
    end

    test "|vacnt|house|" do
      assert Game.estates_from_row(
               [false, true],
               [true, true]
             ) == [0, 1]
    end

    test "|house|vacnt|" do
      assert Game.estates_from_row(
               [true, false],
               [true, true]
             ) == [1, 0]
    end

    test "|house house|house|" do
      assert Game.estates_from_row(
               [true, true, true],
               [false, false, true]
             ) == [100]
    end

    test "|house house house|house house|" do
      assert Game.estates_from_row(
               [true, true, true, true, true],
               [false, false, true, false, true]
             ) == [100, 10]
    end

    test "|house vacnt house|house house|" do
      assert Game.estates_from_row(
               [true, false, true, true, true],
               [false, false, true, false, true]
             ) == [0, 10]
    end
  end
end
