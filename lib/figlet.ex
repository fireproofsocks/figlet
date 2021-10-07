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
  See <https://github.com/patorjk/figlet-cli> and
  <https://github.com/patorjk/figlet.js>
  """

  alias Figlet.Parser.FontFileParser

  @horizontal_layouts [:default, :full, :fitted, :controlled_smushing, :universal_smushing]
  @vertical_layouts [:default, :full, :fitted, :controlled_smushing, :universal_smushing]
  @default_font "ours/banner.flf"
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

  @fonts_dir [__DIR__, "..", "fonts"] |> Path.join() |> Path.expand()

  @doc """
  Prints text in all available fonts.

  ## Examples

      iex> Figlet.demo("Foo")
      ...

      fonts/figlet.js/Modular.flf
      _______  _______  _______
      |       ||       ||       |
      |    ___||   _   ||   _   |
      |   |___ |  | |  ||  | |  |
      |    ___||  |_|  ||  |_|  |
      |   |    |       ||       |
      |___|    |_______||_______|
      fonts/figlet.js/Roman.flf
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
        font |> Path.relative_to(@fonts_dir) |> IO.puts()
        text(text, font: font)
        IO.puts("")
      end)
    end
  end

  @doc """
  Render the `input` text into representations using the given font (see `opts`).

  ## Options

  - `font`: string path to font file, e.g. `#{@default_font}`. Relative paths are
    interpretted as relative to this package's `fonts/` directory.
  - `horizontal_layout`: default: `#{@default_horizontal_layout}`
  - `vertical_layout`: default: `#{@default_vertical_layout}`
  - `width`: integer character screen width, default: `#{@default_width}`,
  - `whitespace_break`: default: `#{@default_whitespace_break}`

  ## Examples

      iex> Figlet.text("Jump Street", font: "ours/ivrit.flf")
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
      |> make_absolute()
      |> FontFileParser.parse()

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

      iex> Figlet.font("figlet.js/Alpha.flf")
  """
  def font(path) do
    path
    |> make_absolute()
    |> FontFileParser.parse()
  end

  @doc """
  Show the fonts currently included with this package.
  Fonts are identified by their relative paths.

  ## Examples

      iex> Figlet.list_fonts()
      {:ok,
        ["contributed/nipples.flf", ...]
  """
  @spec list_fonts :: {:ok, list} | {:error, any()}
  def list_fonts do
    @fonts_dir
    |> ls_files_r()
    |> case do
      {:ok, dir_contents} ->
        {:ok,
         dir_contents
         |> Enum.map(fn f -> Path.relative_to(f, @fonts_dir) end)
         |> Enum.to_list()}

      {:error, error} ->
        {:error, error}
    end
  end

  def ls_files_r(filepath) when is_binary(filepath) do
    case File.dir?(filepath) do
      true -> {:ok, expand(File.ls(filepath), filepath)}
      false -> {:error, "#{filepath} is not a directory"}
    end
  end

  # We skip directories by routing execution based on the output of File.ls
  defp expand({:ok, files}, path) do
    files
    |> Stream.flat_map(&expand(File.ls("#{path}/#{&1}"), "#{path}/#{&1}"))
  end

  # Here is a file (ls of a file will cause an error, so we return its path)
  defp expand({:error, _}, path), do: [path]

  defp make_absolute("/" <> _ = filepath), do: Path.expand(filepath)
  defp make_absolute(filepath), do: Path.expand(filepath, @fonts_dir)
end
