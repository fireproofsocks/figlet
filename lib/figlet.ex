defmodule Figlet do
  @moduledoc """
  A [FIGlet](https://en.wikipedia.org/wiki/FIGlet) is a program for making large
  letters out of ordinary text characters, like this:

  ```
  ███████╗██╗ ██████╗ ██╗     ███████╗████████╗    ██████╗ ██╗   ██╗██╗     ███████╗███████╗
  ██╔════╝██║██╔════╝ ██║     ██╔════╝╚══██╔══╝    ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
  █████╗  ██║██║  ███╗██║     █████╗     ██║       ██████╔╝██║   ██║██║     █████╗  ███████╗
  ██╔══╝  ██║██║   ██║██║     ██╔══╝     ██║       ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
  ██║     ██║╚██████╔╝███████╗███████╗   ██║       ██║  ██║╚██████╔╝███████╗███████╗███████║
  ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚══════╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝
  ```

  Inspired by [patorjk's Text to ASCII Art Generator](http://patorjk.com/software/taag/). Thanks `patorjk`!
  See https://github.com/patorjk/figlet-cli
  https://github.com/patorjk/figlet.js
  """

  alias Figlet.Parser.FileParser, as: Parser

  @horizontal_layouts [:default, :full, :fitted, :controlled_smushing, :universal_smushing]
  @vertical_layouts [:default, :full, :fitted, :controlled_smushing, :universal_smushing]
  @default_font "priv/ours/banner.flf"
  @default_horizontal_layout :default
  @default_vertical_layout :default
  @default_width 80
  @default_whitespace_break true

  @defaults [
    font: @default_font,
    horizontal_layout: @default_horizontal_layout,
    vertical_layout: @default_vertical_layout,
    whitespace_break: @default_whitespace_break
  ]

  @doc """
  Render the `input` text into representations using the given font (see `opts`).

  ## Options

      - `font`: string path to font file, e.g. `#{@default_font}`,
      - `horizontal_layout`: default: `#{@default_horizontal_layout}`
      - `vertical_layout`: default: `#{@default_vertical_layout}`
      - `width`: integer character screen width, default: `#{@default_width}`,
      - `whitespace_break`: default: `#{@default_whitespace_break}`

  ## Examples

      iex> Figlet.text("Jump Street", font: "priv/ours/ivrit.flf")
            _                                 ____    _                          _
           | |  _   _   _ __ ___    _ __     / ___|  | |_   _ __    ___    ___  | |_
        _  | | | | | | | '_ ` _ \  | '_ \    \___ \  | __| | '__|  / _ \  / _ \ | __|
       | |_| | | |_| | | | | | | | | |_) |    ___) | | |_  | |    |  __/ |  __/ | |_
        \___/   \__,_| |_| |_| |_| | .__/    |____/   \__| |_|     \___|  \___|  \__|
                                   |_|
  """
  def text(input, opts \\ []) when is_binary(input) do
    {:ok, font} =
      opts
      |> Keyword.get(:font, @default_font)
      |> Parser.parse()

    charlist = String.to_charlist(input)

    Enum.each(1..font.meta.height, fn x ->
      Enum.reduce(charlist, "", fn chr, slice_acc ->
        slice_acc <> font.char_map[chr].slices[x]
      end)
      |> String.replace(font.meta.hard_blank, " ")
      |> IO.puts()
    end)
  end

  @doc """
  Retrieves font at the given path
  """
  def font(path) do
    Parser.parse(path)
  end

  def list_fonts do
    # TODO
  end
end
