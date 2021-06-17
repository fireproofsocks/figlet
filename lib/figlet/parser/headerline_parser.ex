defmodule Figlet.Parser.HeaderlineParser do
  @moduledoc """
  This module is dedicated to parsing the metadata from a Figlet file headerline.

  The [header line](http://www.jave.de/figlet/figfont.html#headerline) gives
  information about the FIGfont.  Here is an example showing the names of all
  parameters:

  ```
            flf2a$ 6 5 20 15 3 0 143 229    NOTE: The first five characters in
              |  | | | |  |  | |  |   |     the entire file must be "flf2a".
             /  /  | | |  |  | |  |    \
    Signature  /  /  | |  |  | |   \   Codetag_Count
      Hardblank  /  /  |  |  |  \   Full_Layout*
           Height  /   |  |   \  Print_Direction
           Baseline   /    \   Comment_Lines
            Max_Length      Old_Layout*
  ```

  * The two layout parameters are closely related and fairly complex.
  (See [INTERPRETATION OF LAYOUT PARAMETERS](http://www.jave.de/figlet/figfont.html#interpretlayout))

  ## See Also

  - http://www.jave.de/figlet/figfont.html
  - http://www.jave.de/docs/figfont.txt
  - https://github.com/Marak/asciimo/issues/3
  """
  alias Figlet.Meta

  # Provide default values as strings so they can be properly converted
  @defaults %{
    codetag_count: "0",
    full_layout: "0",
    print_direction: "0"
  }

  @doc """
  Parses the headerline (provided as a string binary).
  """
  @spec parse(header_line :: binary, opts :: keyword()) :: {:ok, Meta.t()} | {:error, binary()}
  def parse(header_line, opts \\ [])

  def parse("flf2" <> <<_::binary-size(1), hard_blank::binary-size(1)>> <> tail, _) do
    tail
    |> String.trim()
    |> String.split(" ")
    |> metadata()
    |> case do
      {:ok, metadata} -> {:ok, struct(Meta, Map.put(metadata, :hard_blank, hard_blank))}
      {:error, error} -> {:error, error}
    end
  end

  def parse(_, _) do
    {:error, "Invalid header line: missing flf2a"}
  end

  defp metadata([
         height,
         baseline,
         max_length,
         old_layout,
         comment_lines,
         print_direction,
         full_layout,
         codetag_count
       ]) do
    {:ok,
     %{
       height: height |> String.to_integer(),
       baseline: baseline |> String.to_integer(),
       max_length: max_length |> String.to_integer(),
       old_layout: old_layout |> String.to_integer(),
       comment_lines: comment_lines |> String.to_integer(),
       print_direction: print_direction |> String.to_integer(),
       full_layout: full_layout |> String.to_integer(),
       codetag_count: codetag_count |> String.to_integer()
     }}
  end

  # If a headerline omits optional arguments, we pad it with defaults
  defp metadata([_, _, _, _, _, _, _] = data), do: metadata(data ++ [@defaults[:codetag_count]])

  defp metadata([_, _, _, _, _, _] = data),
    do: metadata(data ++ [@defaults[:full_layout], @defaults[:codetag_count]])

  defp metadata([_, _, _, _, _] = data),
    do:
      metadata(
        data ++ [@defaults[:print_direction], @defaults[:full_layout], @defaults[:codetag_count]]
      )

  defp metadata(_) do
    {:error, "Invalid metadata"}
  end
end
