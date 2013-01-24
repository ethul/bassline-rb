module Bassline
  # algebraic data type Either = Left | Right is typically used to model error | success
  # and we need to have a stored value representing the error. this can be compared to
  # Maybe which just tells us an error occured (Nothing) but not what it was. here we
  # can store the error in Left(error) and the success in Right(success)
  class Either
    attr_reader :get

    def initialize a
      @get = a
    end

    # fmap :: (a -> b) -> Either e a -> Either e b
    def fmap f
      case self
      when Left then Left.new(get)
      when Right then Right.new(f.curry.(get))
      end
    end

    # ap :: Either e (a -> b) -> Either e a -> Either e b
    def ap f
      case self
      when Left
        case f
        when Left
          get.respond_to?(:+) ?
            Left.new(get + f.get) :
            Left.new(get)
        when Right
          Left.new(get)
        end
      when Right
        f.fmap(get)
      end
    end

    # bind :: Either e a -> (a -> Either e b) -> Either e b
    def bind f
      case self
      when Left then Left.new(get)
      when Right then f.curry.(get)
      end
    end

    # fold :: (a -> b) -> (e -> b) -> Either a e -> b
    def fold f,g
      case self
      when Left then f.(get)
      when Right then g.(get)
      end
    end

    class << self
      # pure :: a -> Either e a
      def pure a
        Right.new(a)
      end

      # return :: a -> Either e a
      def return a
        Right.new(a)
      end
    end
  end

  class Left < Either; end
  class Right < Either; end
end
