# Welcome2 Game Server

## Installation

Clone the repo and get the dependencies

$ git clone https://github.com/philihp/welcome2_game.git
$ git clone https://github.com/philihp/welcome2_constants.git
$ cd welcome2_game
$ mix deps.get

## Startup

From the `welcome2_game` folder, run

```
$ iex --name welcome2_game -S mix
```

You should see a prompt that looks like

```
iex(welcome2_game@HOSTNAME)1>
```

That's it!

## Useful

While you probably want to use the `welcome2_cli` to play games, you can also create them directly in the `iex` console...

```elixir
g = Welcome2Game.Game.new_game
g |> Welcome2Game.Game.view
```

You can pipe the state into a pipeline of move reducers

```elixir
g2 = g |> Welcome2Game.Game.permit(1) |> Welcome2Game.Game.build(:b, 7) |> Welcome2Game.Game.commit
g2 |> Welcome2Game.Game.view
```
