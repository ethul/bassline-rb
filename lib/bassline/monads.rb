module Bassline
  # return :: a -> f a
  # bind :: f a -> (a -> f b) -> f b
  module Monads
    module Maybe
      # return :: a -> Maybe a
      module Class
        def return a
          Bassline::Just.new a
        end
      end

      # bind :: Maybe a -> (a -> Maybe b) -> Maybe b
      module Nothing
        def bind f
          Bassline::Nothing.new
        end
      end
      module Just
        def bind f
          f.curry.(get)
        end
      end
    end

    module Either
      # return :: a -> Either e a
      module Class
        def return a
          Bassline::Right.new a
        end
      end

      # bind :: Either e a -> (a -> Either e b) -> Either e b
      module Left
        def bind f
          Bassline::Left.new get
        end
      end
      module Right
        def bind f
          f.curry.(get)
        end
      end
    end
  end
end
