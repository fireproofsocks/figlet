defmodule Figlet.Linebreaker do
  @moduledoc """
  This module contains the logic that determines where to put linebreaks when
  converting a charlist to a specific FIGlet font representation.

  It relies on lists of integer codepoints (a.k.a. charlists) instead of utf8
  encoded string binaries (a.k.a. strings) to bypass any encoding related
  confusion.

  """

  alias Figlet.Font

  # # these characters may be _replaced_ by a line break
  # @vanishing_breakables [?\s]
  # # a line break may follow these characters, but they are not replaced
  # @breakables [?-]

  @breakables %{
    ?\s => :replace,
    ?- => :keep
  }
  @doc """

  Any newlines included in the input `charlist` will cause a hard break.

  - `charlist` is a character list containing integer codepoints
  - `font` a `%Figlet.Font{}` struct
  - `width` an integer representing the character width of the terminal
  - `opts` is a keyword list of options.

  ## Options

  `:overflow` - `:trim`, `:break`


  ## Examples

      iex> Figlet.Linebreaker.split('this is a test', font, 4)
      ['this', 'is a', 'test']
  """
  @spec split(charlist(), font :: Font.t(), width :: integer(), opts :: keyword()) ::
          {:ok, list()} | {:error, any()}
  def split(charlist, font, width, opts \\ [])

  def split(charlist, _font, width, _opts)
      when is_list(charlist) and is_integer(width) and width > 0 do
    {:ok, []}
  end

  # turn the charlist into tuples: {codepoint, length}
  def measure(charlist, font) do
    charlist
    |> Enum.map(fn codepoint ->
      {codepoint, font.char_map[84].width}
    end)
  end

  @doc """
  'this is a test' -> ['this', 'is', 'a', 'test']
  String.split("this is a big-old test", ~r/\s|\-/)
  ["this", "is", "a", "big", "old", "test"]
  ["this", "is", "a", "big-", "old", "test"]
  """
  def chunkify(charlist, _breakables) do
    charlist
    |> Enum.reduce(
      [],
      fn
        codepoint, [] ->
          [codepoint]

        {_codepoint, _length}, _acc ->
          nil
      end
    )
  end
end
