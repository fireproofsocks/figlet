defmodule Figlet.Meta do
  @moduledoc """
  Contains meta data about a Figlet font parsed from its header row.

  ## Keys

  - `:hard_blank` the character that represents "hard", un-squishable space.
  - `:height` the number of rows used by each character.
  - `:max_length`
  - `:old_layout`
  - `:comment_lines` the number of comment lines used before character data begins.
  - `:print_direction` `0` : left to right. `1` : right to left.
  - `:full_layout`
  - `:codetag_count`
  """
  @type t :: %__MODULE__{
          hard_blank: binary(),
          height: integer(),
          baseline: integer(),
          max_length: integer(),
          old_layout: integer(),
          comment_lines: integer(),
          print_direction: integer(),
          full_layout: integer(),
          codetag_count: integer()
        }

  defstruct hard_blank: nil,
            height: nil,
            baseline: nil,
            max_length: nil,
            old_layout: nil,
            comment_lines: nil,
            print_direction: nil,
            full_layout: nil,
            codetag_count: nil
end
