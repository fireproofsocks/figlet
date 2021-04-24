defmodule Figlet.Parser.HeaderlineParserTest do
  use ExUnit.Case

  alias Figlet.Meta
  alias Figlet.Parser.HeaderlineParser, as: P

  describe "parse/2" do
    test ":ok" do
      assert {:ok,
              %Meta{
                baseline: 3,
                codetag_count: 0,
                comment_lines: 11,
                full_layout: 10127,
                hard_blank: "\d",
                height: 4,
                max_length: 8,
                old_layout: 15,
                print_direction: 0
              }} = P.parse("flf2a 4 3 8 15 11 0 10127")
    end

    test ":error on header without opening signature" do
      assert {:error, _} = P.parse("not a flf file")
    end

    test ":error on header with too many items" do
      assert {:error, _} = P.parse("flf2a$ 8 6 59 15 10 0 2 5 6 7")
    end

    test ":error on header with too few items" do
      assert {:error, _} = P.parse("flf2a$ 8 6 4 3")
    end
  end
end
