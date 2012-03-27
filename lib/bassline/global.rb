module Bassline
  # Defines types of bassline into the global namespace for convenience.
  # Note that this is completely opt-in as this file will not be
  # automatically required. If you want the following, just do
  #
  #   require "bassline/global"
  #
  ::Maybe = Bassline::Maybe
  ::Just = Bassline::Just
  ::Nothing = Bassline::Nothing
  ::Either = Bassline::Either
  ::Left = Bassline::Left
  ::Right = Bassline::Right
end
