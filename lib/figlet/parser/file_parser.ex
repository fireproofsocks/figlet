defmodule Figlet.Parser.FileParser do
  @moduledoc """
  This module parses figlet files.
  How the files are read (e.g. in whole or streamed) is an implementation detail.


  Figlet font file format spec:
  http://www.jave.de/docs/figfont.txt
  https://github.com/Marak/asciimo/issues/3

  A FIGlet file has 3 main parts:

  - Headerline
  - Comments
  - Character Data



  ## [FIGcharacter Data](http://www.jave.de/figlet/figfont.html#figcharacterdata)
  The FIGcharacter data begins on the next line after the comments and continues
  to the end of the file.

  ## Basic Data Structure
  The sub-characters in the file are given exactly as they should be output, with
  two exceptions:

  1. Hardblanks should be the hardblank character specified in the header line, not a blank (space).
  2. Every line has one or two endmark characters, whose column locations define the width of each FIGcharacter.

  In most FIGfonts, the endmark character is either "@" or "#". The FIGdriver will
  eliminate the last block of consecutive equal characters from each line of
  sub-characters when the font is read in. By convention, the last line of a
  FIGcharacter has two endmarks, while all the rest have one. This makes it easy
  to see where FIGcharacters begin and end. No line should have more than two endmarks.
  """

  alias Figlet.{Char, Font, Meta}
  alias Figlet.Parser.HeaderlineParser

  @reqd_codepoints Enum.concat(32..126, [196, 214, 220, 228, 246, 252, 223])

  defmodule Error do
    @moduledoc false
    defexception message: "parser error"
  end

  @doc """
  Parses the Figlet font file at the given `filepath`, returning a `%Figlet.Font{}`
  struct.

  Given:
  flf2a 4 3 8 15 11 0 10127

  The 6th character (after the a) is a unicode value for "hardBlank"

  All FIGlet fonts must contain chars 32-126, 196, 214, 220, 228, 246, 252, 223
  """
  def parse(filepath, opts \\ [])

  def parse(filepath, _opts) when is_binary(filepath) do
    case File.exists?(filepath) do
      true ->
        filepath
        |> File.stream!([], :line)
        |> Enum.reduce({:headerline, %Font{source: filepath}}, &parse_line/2)
        |> case do
          {:chardata, _, font, _, _} -> {:ok, font}
          _other -> {:error, "Something else happened"}
        end

      false ->
        {:error, "File not found: #{inspect(filepath)}"}
    end
  end

  #
  # acc: {<task>, tmp_acc, %Font{}, line_i}
  # acc: {:comments, tmp_acc, font, line_i}
  defp parse_line(header, {:headerline, font}) do
    case HeaderlineParser.parse(header) do
      {:ok, meta} ->
        {:comments, "", Map.put(font, :meta, meta), 2}

      {:error, error} ->
        raise Error, message: error
    end
  end

  # After the headerline, accumulate comments
  defp parse_line(
         line,
         {:comments, comment_acc, %Font{meta: %Meta{comment_lines: comment_lines}} = font, line_i}
       )
       when line_i <= comment_lines do
    {:comments, comment_acc <> line, font, line_i + 1}
  end

  # Final comment line / transition to chardata
  defp parse_line(
         line,
         {:comments, comment_acc, %Font{} = font, _line_i}
       ) do
    [codepoint | rem_codepoints] = @reqd_codepoints

    {:chardata, %Char{codepoint: codepoint}, Map.put(font, :comments, comment_acc <> line),
     rem_codepoints, 1}
  end

  # After the comments, accumulate the chardata
  # acc: {:chardata, tmp_acc, font, codepoint, rem_codepoints, line_i}
  # http://www.jave.de/figlet/figfont.html#figcharacterdata
  defp parse_line(
         line,
         {:chardata, char, %Font{meta: %{height: height}} = font, rem_codepoints, line_i}
       )
       when line_i < height do
    updated_char =
      update_in(char.slices, fn slices -> Map.put(slices, line_i, trim_endmarks(line)) end)

    {:chardata, updated_char, font, rem_codepoints, line_i + 1}
  end

  # last line of the char
  defp parse_line(
         line,
         {:chardata, char, %Font{meta: %{height: height}} = font,
          [new_codepoint | rem_codepoints], line_i}
       )
       when line_i == height do
    line_data = trim_endmarks(line)

    updated_char =
      update_in(char.slices, fn slices -> Map.put(slices, line_i, line_data) end)
      |> Map.put(:width, String.length(line_data))

    updated_font =
      update_in(font.char_map, fn char_map -> Map.put(char_map, char.codepoint, updated_char) end)

    {:chardata, %Char{codepoint: new_codepoint}, updated_font, rem_codepoints, 1}
  end

  # TODO: ad-hoc chars
  # defp parse_line(_line, {:chardata, tmp_acc, font, codepoint, [], 1}) do
  # defp parse_line(_line, {:chardata, _tmp_acc, font, _codepoint, [], _}) do
  defp parse_line(_line, acc) do
    # IO.puts("DONE")
    # nil
    acc
  end

  # In most FIGfonts, the endmark character is either "@" or "#", but
  # we assume it is the character that _precedes_ the newline.
  defp trim_endmarks(line_acc) do
    line_acc = String.trim_trailing(line_acc, "\n")
    endmark = String.last(line_acc)
    String.trim_trailing(line_acc, endmark)
  end
end
