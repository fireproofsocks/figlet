defmodule Figlet do
  @moduledoc """
  A [FIGlet](https://en.wikipedia.org/wiki/FIGlet) is a program for making large
  letters out of ordinary text characters, like this:


         ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄         ▄
        ▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌          ▐░▌       ▐░▌
        ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌          ▐░▌       ▐░▌
        ▐░▌       ▐░▌     ▐░▌     ▐░▌          ▐░▌          ▐░▌       ▐░▌
        ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░▌ ▄▄▄▄▄▄▄▄ ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌
        ▐░░░░░░░░░░▌      ▐░▌     ▐░▌▐░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌
        ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░▌ ▀▀▀▀▀▀█░▌▐░▌           ▀▀▀▀█░█▀▀▀▀
        ▐░▌       ▐░▌     ▐░▌     ▐░▌       ▐░▌▐░▌               ▐░▌
        ▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌
        ▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌
         ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀


  (Please note that the formatting inside the docs may not be accurate)

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
  Prints text in all available fonts.

  ## Examples

      iex> Figlet.demo("Foo")
      ...

      priv/figlet.js/Modular.flf
      _______  _______  _______
      |       ||       ||       |
      |    ___||   _   ||   _   |
      |   |___ |  | |  ||  | |  |
      |    ___||  |_|  ||  |_|  |
      |   |    |       ||       |
      |___|    |_______||_______|
      priv/figlet.js/Roman.flf
      oooooooooooo
      `888'     `8
      888          .ooooo.   .ooooo.
      888oooo8    d88' `88b d88' `88b
      888    "    888   888 888   888
      888         888   888 888   888
      o888o        `Y8bod8P' `Y8bod8P'
      ...
      :ok
  """
  def demo(text) do
    with {:ok, fonts} <- list_fonts() do
      Enum.each(fonts, fn font ->
        IO.puts(font)
        text(text, font: font)
      end)
    end
  end

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
  Retrieves info about the font at the given path. This is used internally
  before rendering text.

  ## Examples

      iex> Figlet.font("priv/figlet.js/Alpha.flf")
  """
  def font(path) do
    Parser.parse(path)
  end

  @doc """
  Show the fonts currently included with this package.

  ## Examples

      iex> Figlet.list_fonts()
      {:ok,
        ["priv/contributed/nipples.flf", ...]
  """
  @spec list_fonts :: {:ok, list} | {:error, any()}
  def list_fonts do
    "priv"
    |> ls_files_r()
    |> case do
      {:ok, func} -> {:ok, Enum.to_list(func)}
      {:error, error} -> {:error, error}
    end
  end

  def ls_files_r(filepath) when is_binary(filepath) do
    case File.dir?(filepath) do
      true -> {:ok, expand(File.ls(filepath), filepath)}
      false -> {:error, :enotdir}
    end
  end

  # We skip directories by routing execution based on the output of File.ls
  defp expand({:ok, files}, path) do
    files
    |> Stream.flat_map(&expand(File.ls("#{path}/#{&1}"), "#{path}/#{&1}"))
  end

  # Here is a file (ls of a file will cause an error, so we return its path)
  defp expand({:error, _}, path), do: [path]
end
