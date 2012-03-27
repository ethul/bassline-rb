module Bassline
  class Maybe
    extend Applicatives::Maybe::Class
    extend Monads::Maybe::Class

    def get_or b
      fold -> {b}, ->a {a}
    end
  end

  class Nothing < Maybe
    include Functors::Maybe::Nothing
    include Applicatives::Maybe::Nothing
    include Monads::Maybe::Nothing
    def fold f,g
      f.()
    end
  end

  class Just < Maybe
    include Functors::Maybe::Just
    include Applicatives::Maybe::Just
    include Monads::Maybe::Just
    attr_reader :get
    def initialize a
      @get = a
    end
    def fold f,g
      g.(get)
    end
  end
end
