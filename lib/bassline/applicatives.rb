module Bassline
  # pure :: a -> f a
  # ap :: f (a -> b) -> f a -> f b
  #
  # we want to apply the (a -> b) to the functor f a so
  # below we invoke fmap on fa passing it the (a -> b) that
  # is inside the current object. we don't reverse the params
  # here since we want to write the applicative with the
  # function first this time like
  # Just(->(a) {->(b) {}}).ap(Just(a)).ap(Just(b))
  module Applicatives
    module Maybe
      # pure :: a -> Maybe a
      module Class
        def pure a
          Bassline::Just.new a
        end
      end

      # ap :: Maybe (a -> b) -> Maybe a -> Maybe b
      module Nothing
        def ap f
          Bassline::Nothing.new
        end
      end
      module Just
        def ap f
          f.fmap get
        end
      end
    end

    module Either
      # pure :: a -> Either e a
      module Class
        def pure a
          Bassline::Right.new a
        end
      end

      # ap :: Either e (a -> b) -> Either e a -> Either e b
      module Left
        def ap f
          f.fold ->e {
            if get.respond_to?("concat") then Bassline::Left.new(get.concat f.get)
            else Bassline::Left.new get end
          }, ->a {Bassline::Left.new get}
        end
      end
      module Right
        def ap f
          f.fmap get
        end
      end
    end
  end
end
