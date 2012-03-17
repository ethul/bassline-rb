require "spec_helper"

describe Bassline::Monads do
  describe "when maybe's bind is invoked" do
    it "should hold to left identity: forall f,a . f(a) == return(a).bind(f)" do
      f = ->(a) {Bassline::Just.new(a)}
      a = 10
      f.(a).get.should == Bassline::Just.new(a).bind(f).get
    end
    it "should hold to right identity: forall ma . ma == ma.bind(x -> return(x))" do
      a = 10
      Bassline::Just.new(a).get.should == Bassline::Just.new(a).bind(->(x){Bassline::Maybe.return(x)}).get
      Bassline::Nothing.new.class.name.should == Bassline::Nothing.new.bind(->(x){Bassline::Maybe.return(x)}).class.name
    end
    it "should hold to associativity: forall ma,f,g . (ma.bind(f)).bind(g) == ma.bind(x -> f(x).bind(g))" do
      a = 10
      f = ->(a) {Bassline::Just.new(a+10)}
      g = ->(a) {Bassline::Just.new(a+30)}
      (Bassline::Just.new(a).bind(f)).bind(g).get.should == Bassline::Just.new(a).bind(->(x){f.(x).bind(g)}).get
      (Bassline::Nothing.new.bind(f)).bind(g).class.name.should == Bassline::Nothing.new.bind(->(x){f.(x).bind(g)}).class.name
    end
  end

  describe "when either's bind is invoked" do
    it "should hold to left identity: forall f,a . f(a) == return(a).bind(f)" do
      a = 10

      f = ->(x) {Bassline::Right.new(x)}
      f.(a).get.should == Bassline::Either.return(a).bind(f).get

      f = ->(x) {Bassline::Left.new(x)}
      f.(a).get.should == Bassline::Either.return(a).bind(f).get
    end

    it "should hold to right identity: forall ma . ma == ma.bind(x -> return(x))" do
      a = 10
      Bassline::Right.new(a).get.should == Bassline::Right.new(a).bind(->(x){Bassline::Either.return(x)}).get
      Bassline::Left.new(a).get.should == Bassline::Left.new(a).bind(->(x){Bassline::Either.return(x)}).get
    end

    it "should hold to associativity: forall ma,f,g . (ma.bind(f)).bind(g) == ma.bind(x -> f(x).bind(g))" do
      a = 10

      f = ->(a) {Bassline::Right.new(a+10)}
      g = ->(a) {Bassline::Right.new(a+30)}
      (Bassline::Right.new(a).bind(f)).bind(g).get.should == Bassline::Right.new(a).bind(->(x){f.(x).bind(g)}).get

      f = ->(a) {Bassline::Left.new(a+10)}
      g = ->(a) {Bassline::Right.new(a+30)}
      (Bassline::Right.new(a).bind(f)).bind(g).get.should == Bassline::Right.new(a).bind(->(x){f.(x).bind(g)}).get

      f = ->(a) {Bassline::Left.new(a+10)}
      g = ->(a) {Bassline::Left.new(a+30)}
      (Bassline::Right.new(a).bind(f)).bind(g).get.should == Bassline::Right.new(a).bind(->(x){f.(x).bind(g)}).get

      f = ->(a) {Bassline::Right.new(a+10)}
      g = ->(a) {Bassline::Left.new(a+30)}
      (Bassline::Right.new(a).bind(f)).bind(g).get.should == Bassline::Right.new(a).bind(->(x){f.(x).bind(g)}).get

      f = ->(a) {Bassline::Right.new(a+10)}
      g = ->(a) {Bassline::Right.new(a+30)}
      (Bassline::Left.new(a).bind(f)).bind(g).get.should == Bassline::Left.new(a).bind(->(x){f.(x).bind(g)}).get

      f = ->(a) {Bassline::Right.new(a+10)}
      g = ->(a) {Bassline::Left.new(a+30)}
      (Bassline::Left.new(a).bind(f)).bind(g).get.should == Bassline::Left.new(a).bind(->(x){f.(x).bind(g)}).get

      f = ->(a) {Bassline::Left.new(a+10)}
      g = ->(a) {Bassline::Right.new(a+30)}
      (Bassline::Left.new(a).bind(f)).bind(g).get.should == Bassline::Left.new(a).bind(->(x){f.(x).bind(g)}).get

      f = ->(a) {Bassline::Left.new(a+10)}
      g = ->(a) {Bassline::Left.new(a+30)}
      (Bassline::Left.new(a).bind(f)).bind(g).get.should == Bassline::Left.new(a).bind(->(x){f.(x).bind(g)}).get
    end
  end
end
