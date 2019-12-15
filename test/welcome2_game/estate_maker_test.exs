defmodule Welcome2Game.EstateMakerTest do
  alias Welcome2Game.{EstateMaker, Tableau}
  use ExUnit.Case

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

      assert EstateMaker.houses_from_player(player, :a, 10) ===
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

      assert EstateMaker.fences_from_player(player, :a, 10) ===
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

      assert EstateMaker.estates_from_player(player, :a) == %{
               0 => 2,
               3 => 1
             }
    end
  end

  describe "#estates_from_row" do
    test "|house|" do
      assert EstateMaker.estates_from_row(
               [true],
               [true]
             ) == [1]
    end

    test "|vacnt|" do
      assert EstateMaker.estates_from_row(
               [false],
               [true]
             ) == [0]
    end

    test "|house house|" do
      assert EstateMaker.estates_from_row(
               [true, true],
               [false, true]
             ) == [10]
    end

    test "|house vacnt|" do
      assert EstateMaker.estates_from_row(
               [true, false],
               [false, true]
             ) == [0]
    end

    test "|vacnt house|" do
      assert EstateMaker.estates_from_row(
               [false, true],
               [false, true]
             ) == [0]
    end

    test "|house house house|" do
      assert EstateMaker.estates_from_row(
               [true, true, true],
               [false, false, true]
             ) == [100]
    end

    test "|house vacnt|house|" do
      assert EstateMaker.estates_from_row(
               [true, false, true],
               [false, true, true]
             ) == [0, 1]
    end

    test "|house|house|" do
      assert EstateMaker.estates_from_row(
               [true, true],
               [true, true]
             ) == [1, 1]
    end

    test "|vacnt|house|" do
      assert EstateMaker.estates_from_row(
               [false, true],
               [true, true]
             ) == [0, 1]
    end

    test "|house|vacnt|" do
      assert EstateMaker.estates_from_row(
               [true, false],
               [true, true]
             ) == [1, 0]
    end

    test "|house house|house|" do
      assert EstateMaker.estates_from_row(
               [true, true, true],
               [false, false, true]
             ) == [100]
    end

    test "|house house house|house house|" do
      assert EstateMaker.estates_from_row(
               [true, true, true, true, true],
               [false, false, true, false, true]
             ) == [100, 10]
    end

    test "|house vacnt house|house house|" do
      assert EstateMaker.estates_from_row(
               [true, false, true, true, true],
               [false, false, true, false, true]
             ) == [0, 10]
    end
  end
end
