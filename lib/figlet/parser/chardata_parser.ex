defmodule Figlet.Parser.ChardataParse do
  @moduledoc """
  This module focuses on parsing character data from Figlet files.
  http://www.jave.de/figlet/figfont.html#figcharacterdata

  ## FIGcharacter Data
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
  @doc """
  Some FIGcharacters are required, and must be represented in a specific order.
  The following codepoints are required:
  32-126, 196, 214, 220, 228, 246, 252, and 223 **in that order.**
  """
  def reqd_codepoints do
    Stream.concat(32..126, [196, 214, 220, 228, 246, 252, 223])
  end

  # def parse(line, ) do
  # end
end
