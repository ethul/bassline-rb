module Bassline
  # fmap :: (a -> b) -> f a -> f b
  #
  # but we use f a -> (a -> b) -> f b since the f a
  # is the current object instance
  module Functors
    # fmap :: (a -> b) -> Maybe a -> Maybe b
    module Maybe
      module Nothing
        def fmap f
          Bassline::Nothing.new
        end
      end
      module Just
        def fmap f
          Bassline::Just.new f.curry.(get)
        end
      end
    end

    # fmap :: (a -> b) -> Either e a -> Either e b
    module Either
      module Left
        def fmap f
          Bassline::Left.new get
        end
      end
      module Right
        def fmap f
          Bassline::Right.new f.curry.(get)
        end
      end
    end
  end
end
