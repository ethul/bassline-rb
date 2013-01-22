module Bassline
  class ReaderT
    # f :: env -> ma
    def initialize(f)
      @f = f
    end

    def run(env)
      @f.(env)
    end

    # f :: a -> b
    def fmap(f)
      Bassline::ReaderT.new ->env {
        run(env).fmap(f)
      }
    end

    # f :: a -> ReaderT env mb
    def bind(f)
      Bassline::ReaderT.new ->env {
        run(env).bind ->a {
          f.(a).run(env)
        }
      }
    end

    class << self
      def return(ma)
        Bassline::ReaderT.new ->_ {
          ma
        }
      end

      def ask(m)
        Bassline::ReaderT.new ->env {
          m.new(env)
        }
      end
    end
  end
end
