module Bassline
  class Maybe
    # fmap :: (a -> b) -> Maybe a -> Maybe b
    def fmap f
      case self
      when Nothing then Nothing.new
      when Just then Just.new(f.curry.(get))
      end
    end

    # ap :: Maybe (a -> b) -> Maybe a -> Maybe b
    def ap f
      case self
      when Nothing then Nothing.new
      when Just then f.fmap(get)
      end
    end

    # bind :: Maybe a -> (a -> Maybe b) -> Maybe b
    def bind f
      case self
      when Nothing then Nothing.new
      when Just then f.curry.(get)
      end
    end

    # fold :: (() -> b) -> (a -> b) -> Maybe a -> b
    def fold f,g
      case self
      when Nothing then f.()
      when Just then g.(get)
      end
    end

    def get_or b
      fold(-> {b}, ->a {a})
    end

    class << self
      # pure :: a -> Maybe a
      def pure a
        Just.new(a)
      end

      # return :: a -> f a
      def return a
        Just.new(a)
      end
    end
  end

  class Nothing < Maybe; end
  class Just < Maybe
    attr_reader :get
    def initialize a
      @get = a
    end
  end
end
