module Bassline
  # algebraic data type Either = Left | Right is typically used to model error | success
  # and we need to have a stored value representing the error. this can be compared to
  # Maybe which just tells us an error occured (Nothing) but not what it was. here we
  # can store the error in Left(error) and the success in Right(success)
  class Either
    extend Applicatives::Either::Class
    extend Monads::Either::Class
  end

  class Left < Either
    include Functors::Either::Left
    include Applicatives::Either::Left
    include Monads::Either::Left
    attr_reader :get
    def initialize a
      @get = a
    end
    def fold f,g
      f.(get)
    end
  end

  class Right < Either
    include Functors::Either::Right
    include Applicatives::Either::Right
    include Monads::Either::Right
    attr_reader :get
    def initialize a
      @get = a
    end
    def fold f,g
      g.(get)
    end
  end
end
