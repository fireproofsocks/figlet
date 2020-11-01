defmodule Figlet do
  @moduledoc """
  A [FIGlet](https://en.wikipedia.org/wiki/FIGlet) is a program for making large letters out of ordinary text,
  like this:

  ```
  ███████╗██╗ ██████╗ ██╗     ███████╗████████╗    ██████╗ ██╗   ██╗██╗     ███████╗███████╗
  ██╔════╝██║██╔════╝ ██║     ██╔════╝╚══██╔══╝    ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
  █████╗  ██║██║  ███╗██║     █████╗     ██║       ██████╔╝██║   ██║██║     █████╗  ███████╗
  ██╔══╝  ██║██║   ██║██║     ██╔══╝     ██║       ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
  ██║     ██║╚██████╔╝███████╗███████╗   ██║       ██║  ██║╚██████╔╝███████╗███████╗███████║
  ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚══════╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝
  ```

  Inspired by [patorjk's Text to ASCII Art Generator](http://patorjk.com/software/taag/). Thanks `patorjk`!
  """

  @horizontal_layouts [:default, :full, :fitted, :controlled_smushing, :universal_smushing]
  @vertical_layouts [:default, :full, :fitted, :controlled_smushing, :universal_smushing]
  @default_font "Ghost"
  @default_horizontal_layout :default
  @default_vertical_layout :default
  @default_width 80
  @default_whitespace_break true

  @defaults [font: @default_font, horizontal_layout: @default_horizontal_layout, vertical_layout: @default_vertical_layout, whitespace_break: @default_whitespace_break]

  @doc """
  Render the `input` text into representations using the given font (see `opts`).
  Options

      - `font`: string, e.g. `#{@default_font}`,
      - `horizontal_layout`: default: `#{@default_horizontal_layout}`
      - `vertical_layout`: default: `#{@default_vertical_layout}`
      - `width`: integer, default: `#{@default_width}`,
      - `whitespace_break`: default: `#{@default_whitespace_break}`
  """
  def text(input, opts \\ []) when is_binary(input) do

  end

  @doc """
  Retrieves metadata about the given `font`.
  """
  def metadata(font) do

  end
end
