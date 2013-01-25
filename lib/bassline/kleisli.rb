module Bassline
  # In the instance methods, self comes second in the comment of the
  # type signature; e.g., read run to be run :: a -> self -> m b
  class Kleisli
    # initialize :: (a -> m b)
    #   -> Kleisli m a b
    def initialize(f)
      @f = f
    end

    # run :: a
    #   -> Kleisli m a b
    #   -> m b
    def run(a)
      @f.(a)
    end

    # and_then :: Kleisli m b c
    #   -> Kleisli m a b
    #   -> Kleisli m a c
    def and_then(k)
      Kleisli.new ->a {
        run(a).bind(k.to_proc)
      }
    end

    # and_then_k :: (b -> m c)
    #   -> Kleisli m a b
    #   -> Kleisli m a c
    def and_then_k(k)
      and_then(Kleisli.new(k))
    end

    # compose :: Kleisli m c a
    #   -> Kleisli m a b
    #   -> Kleisli m c b
    def compose(k)
      k.and_then(self)
    end

    # compose_k :: (c -> m a)
    #   -> Kliesli m a b
    #   -> Kleisli m c b
    def compose_k(k)
      compose(Kleisli.new(k))
    end

    # fmap :: (b -> c)
    #   -> Kleisli m a b
    #   -> Kleisli m a c
    def fmap(f)
      Kleisli.new ->a {
        run(a).fmap(f)
      }
    end

    # fmap_k :: (m b -> n c)
    #   -> Kleisli m a b
    #   -> Kleisli n a c
    def fmap_k(f)
      Kleisli.new ->a {
        f.(run(a))
      }
    end

    # bind :: (b -> Kleisli m a c)
    #   -> Kleisli m a b
    #   -> Kleisli m a c
    def bind(f)
      Kleisli.new ->a {
        run(a).bind ->b {
          f.(b).run(a)
        }
      }
    end

    # bind_k :: (b -> m c)
    #   -> Kleisli m a b
    #   -> Kleisli m a c
    def bind_k(f)
      Kleisli.new ->a {
        run(a).bind(f)
      }
    end

    # to_proc :: ()
    #   -> Kleisli m a b
    #   -> (a -> m b)
    def to_proc
      @f
    end

    class << self
      # pure :: m b
      #   -> Kleisli m a b
      def pure(mb)
        Kleisli.new ->_ {
          mb
        }
      end

      # return :: m b
      #   -> Kleisli m a b
      def return(mb)
        Kleisli.new ->_ {
          mb
        }
      end

      # ask :: m
      #   -> Kleisli m a a
      def ask(m)
        Kleisli.new ->a {
          m.pure(a)
        }
      end
    end
  end
end
