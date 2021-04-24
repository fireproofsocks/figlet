defmodule Figlet.Font do
  @moduledoc """
  Stores information about a Figlet font: a container for characters.

  ## Keys

  - `:source` the path to the file that was parsed.
  - `:meta` contains a `Meta` struct.
  - `:comments` comments included by font's author.
  - `:char_map` a map with integer keys representing codepoints and values
    representing how to draw the given character.
  - `:is_valid?` boolean check on whether this represents a complete and valid FIGlet.
  """
  alias Figlet.Meta

  @type t :: %__MODULE__{
          source: binary(),
          meta: Meta.t(),
          comments: binary(),
          char_map: map(),
          is_valid?: boolean()
        }

  defstruct source: nil,
            meta: nil,
            comments: nil,
            char_map: %{},
            is_valid?: nil
end
