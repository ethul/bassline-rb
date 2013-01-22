require "spec_helper"

describe Bassline::ReaderT do
  let(:id){->a {a}}
  let(:compose){->(x,y){->(z){x.(y.(z))}}}
  let(:env){{}}
  let(:a){10}
  let(:fa) {
    Bassline::ReaderT.new ->env {
      Bassline::Just.new(a)
    }
  }

  describe "#fmap" do
    context "identity: forall a . fa(a) == fa(a).fmap(identity)" do
      specify{fa.run(env).get.should == fa.fmap(id).run(env).get}
    end
    context "composition: forall a,f,g . fa(a).fmap(f compose g) = fa(a).fmap(g).fmap(f)" do
      let(:f){->a {a+5}}
      let(:g){->a {a+10}}
      specify{fa.fmap(compose.(f,g)).run(env).get.should == fa.fmap(g).fmap(f).run(env).get}
    end
  end

  describe "#bind" do
    let(:ma){ReaderT.new ->env {Bassline::Just.new(a)}}
    context "left identity: forall f,a . f(a) == return(a).bind(f)" do
      let(:f){->a {ReaderT.new ->env {Bassline::Just.new(a)}}}
      specify{f.(a).run(env).get.should == ma.bind(f).run(env).get}
    end
    context "right identity: forall ma . ma == ma.bind(x -> return(x))" do
      specify{
        ma.run(env).get.should ==
        ma.bind(->x {Bassline::ReaderT.return(Bassline::Maybe.return(x))}).run(env).get
      }
    end
    context "associativity: forall ma,f,g . (ma.bind(f)).bind(g) == ma.bind(x -> f(x).bind(g))" do
      let(:f){->a {ReaderT.new ->env {Bassline::Just.new(a+10)}}}
      let(:g){->a {ReaderT.new ->env {Bassline::Just.new(a+30)}}}
      specify{ma.bind(f).bind(g).run(env).get.should == ma.bind(->x {f.(x).bind(g)}).run(env).get}
    end
  end
end
