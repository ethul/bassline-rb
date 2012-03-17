require "spec_helper"

describe Bassline::Functors do
  describe "when the maybe functor's fmap is invoked" do
    it "should hold to identity: forall a . maybe(a) == maybe(a).fmap(identity)" do
      maybe = Bassline::Just.new(10)
      id = ->(a) {a}
      maybe.get.should == maybe.fmap(id).get
    end
    it "should hold to composition: forall a,f,g . maybe(a).fmap(f compose g) = maybe(a).fmap(g).fmap(f)" do
      compose = ->(x,y){->(z){x.(y.(z))}}
      f = ->(a) {a+5}
      g = ->(a) {a+10}
      a = 10
      Bassline::Just.new(a).fmap(compose.(f,g)).get.should == Bassline::Just.new(a).fmap(g).fmap(f).get
    end
    it "should result in a nothing when fa is nothing" do
      maybe = Bassline::Nothing.new
      maybe.fmap(->(a) {}).class.name.should == Bassline::Nothing.new.class.name
    end
    it "should result in a just when fa is just" do
      x = 5
      maybe = Bassline::Just.new(x)
      f = ->(a) { a + 4 }
      maybe.fmap(f).class.name.should == Bassline::Just.new(x).class.name
      maybe.fmap(f).get.should == f.(x)
    end
  end

  describe "when the either functor's fmap is invoked" do
    it "should hold to identity: forall a . either(a) == either(a).fmap(identity)" do
      id = ->(a) {a}
      Bassline::Right.new(10).get.should == Bassline::Right.new(10).fmap(id).get
      Bassline::Left.new("error").get.should == Bassline::Left.new("error").fmap(id).get
    end
    it "should hold to composition: forall a,f,g . either(a).fmap(f compose g) = either(a).fmap(g).fmap(f)" do
      compose = ->(x,y){->(z){x.(y.(z))}}
      f = ->(a) {a+5}
      g = ->(a) {a+10}
      a = 10
      Bassline::Right.new(a).fmap(compose.(f,g)).get.should == Bassline::Right.new(a).fmap(g).fmap(f).get
      Bassline::Left.new(a).fmap(compose.(f,g)).get.should == Bassline::Left.new(a).fmap(g).fmap(f).get
    end
  end
end
