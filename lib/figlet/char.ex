defmodule Figlet.Char do
  @moduledoc """
  Stores information about a single font character

  ## Keys

  - `:codepoint` integer codepoint for the character being represented.
  - `:width` integer declaring the width (in real characters) of the char
    representation, including any hard blanks
  - `:slices` a map with integer keys (representing line numbers starting with 1)
    and values containing the slice of the char representation for that line.

  ## Examples

  The letter B (from `banner.flf`):

      %Figlet.Char{
        codepoint: 66,
        width: 10,
        slices: %{
              1 => "###### $",
              2 => "#     #$",
              3 => "#     #$",
              4 => "###### $",
              5 => "#     #$",
              6 => "#     #$",
              7 => "###### $",
              8 => "$"
            }
      }
  """

  @type t :: %__MODULE__{
          codepoint: integer(),
          width: integer(),
          slices: map()
        }

  defstruct codepoint: nil,
            width: nil,
            slices: %{}

  # def put_slice(%__MODULE__{} = char, line_i, data) do
  #   update_in(char.slices, fn slices -> Map.put(slices, line_i, data) end)
  # end
end
