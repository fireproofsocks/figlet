# Figlet

This project aims to fully implement the [FIGfont spec](http://www.jave.de/figlet/figfont.html) in Elixir.

Based on the work of Patrick Gillespie for [Javascript Figlet](https://github.com/patorjk/figlet.js).

## Example

```elixir
iex> Figlet.text("Rad", font: "priv/figlet.js/Alpha.flf")
          _____                    _____                    _____
         /\    \                  /\    \                  /\    \
        /::\    \                /::\    \                /::\    \
       /::::\    \              /::::\    \              /::::\    \
      /::::::\    \            /::::::\    \            /::::::\    \
     /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \
    /:::/__\:::\    \        /:::/__\:::\    \        /:::/  \:::\    \
   /::::\   \:::\    \      /::::\   \:::\    \      /:::/    \:::\    \
  /::::::\   \:::\    \    /::::::\   \:::\    \    /:::/    / \:::\    \
 /:::/\:::\   \:::\____\  /:::/\:::\   \:::\    \  /:::/    /   \:::\ ___\
/:::/  \:::\   \:::|    |/:::/  \:::\   \:::\____\/:::/____/     \:::|    |
\::/   |::::\  /:::|____|\::/    \:::\  /:::/    /\:::\    \     /:::|____|
 \/____|:::::\/:::/    /  \/____/ \:::\/:::/    /  \:::\    \   /:::/    /
       |:::::::::/    /            \::::::/    /    \:::\    \ /:::/    /
       |::|\::::/    /              \::::/    /      \:::\    /:::/    /
       |::| \::/____/               /:::/    /        \:::\  /:::/    /
       |::|  ~|                    /:::/    /          \:::\/:::/    /
       |::|   |                   /:::/    /            \::::::/    /
       \::|   |                  /:::/    /              \::::/    /
        \:|   |                  \::/    /                \::/____/
         \|___|                   \/____/                  ~~

:ok
```

This is currently a work in progress: the collection of fonts has not been organized or de-duplicated, there isn't yet support for screen widths or the compression of output, unicode characters, and a handful of other things.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `figlet` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:figlet, "~> 0.1.0"}
  ]
end
```

---------------------------------------------------

Image Attribution: "Braille F" by Joel Wisneski from the [Noun Project](https://thenounproject.com/)
