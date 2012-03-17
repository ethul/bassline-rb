require "spec_helper"

describe Bassline::Applicatives do
  describe "when maybe's ap is invoked" do
    it "should hold to identity: forall a . a == pure(identity).ap(a)" do
      id = ->(a) {a}
      x = Bassline::Just.new(10)
      x.get.should == Bassline::Maybe.pure(id).ap(x).get
      x = Bassline::Nothing.new
      x.class.name.should == Bassline::Maybe.pure(id).ap(x).class.name
    end
    it "should hold to composition: forall af,ag,a . af.ap(ag.ap(a)) == pure(compose).ap(af).ap(ag).ap(a)" do
      compose = ->(a,b){->(x){a.(b.(x))}}

      af = Bassline::Just.new(->(a){a+4})
      ag = Bassline::Just.new(->(a){a+6})
      a = Bassline::Just.new(5)
      af.ap(ag.ap(a)).get.should == Bassline::Maybe.pure(compose).ap(af).ap(ag).ap(a).get

      af = Bassline::Nothing.new
      ag = Bassline::Just.new(->(a){a+6})
      a = Bassline::Just.new(5)
      af.ap(ag.ap(a)).class.name.should == Bassline::Maybe.pure(compose).ap(af).ap(ag).ap(a).class.name

      af = Bassline::Just.new(->(a){a+4})
      ag = Bassline::Nothing.new
      a = Bassline::Just.new(5)
      af.ap(ag.ap(a)).class.name.should == Bassline::Maybe.pure(compose).ap(af).ap(ag).ap(a).class.name

      af = Bassline::Just.new(->(a){a+4})
      ag = Bassline::Just.new(->(a){a+6})
      a = Bassline::Nothing.new
      af.ap(ag.ap(a)).class.name.should == Bassline::Maybe.pure(compose).ap(af).ap(ag).ap(a).class.name

      af = Bassline::Nothing.new
      ag = Bassline::Nothing.new
      a = Bassline::Just.new(5)
      af.ap(ag.ap(a)).class.name.should == Bassline::Maybe.pure(compose).ap(af).ap(ag).ap(a).class.name

      af = Bassline::Nothing.new
      ag = Bassline::Just.new(->(a){a+6})
      a = Bassline::Nothing.new
      af.ap(ag.ap(a)).class.name.should == Bassline::Maybe.pure(compose).ap(af).ap(ag).ap(a).class.name

      af = Bassline::Nothing.new
      ag = Bassline::Nothing.new
      a = Bassline::Nothing.new
      af.ap(ag.ap(a)).class.name.should == Bassline::Maybe.pure(compose).ap(af).ap(ag).ap(a).class.name
    end
    it "should hold to homomorphism: forall f a . pure(f).ap(pure(a)) == pure(f(a))" do
      f = ->(a){a+20}
      a = 10
      Bassline::Maybe.pure(f).ap(Bassline::Maybe.pure(10)).get.should == Bassline::Maybe.pure(f.(a)).get
    end
    it "should hold to interchange: forall af a . af.ap(pure(a)) == pure(->(f) {f.(a)}).ap(af)" do
      f = ->(a){a+10}
      a = 30
      Bassline::Just.new(f).ap(Bassline::Maybe.pure(a)).get.should == Bassline::Maybe.pure(->(g){g.(a)}).ap(Bassline::Just.new(f)).get
      Bassline::Nothing.new.ap(Bassline::Maybe.pure(a)).class.name.should == Bassline::Maybe.pure(->(g){g.(a)}).ap(Bassline::Nothing.new).class.name
    end
    it "should be the same as fmap for all f,x: pure(f).ap(x) == x.fmap(f)" do
      f = ->(a) {a+5}
      x = Bassline::Just.new(20)
      Bassline::Maybe.pure(f).ap(x).get.should == x.fmap(f).get
      Bassline::Maybe.pure(f).ap(Bassline::Nothing.new).class.name.should == Bassline::Nothing.new.fmap(f).class.name
    end
    it "should hold to basic use cases" do
      fab = Bassline::Just.new(->(a) {->(b) {a+b}})
      fab.ap(Bassline::Just.new(10)).ap(Bassline::Just.new(5)).get.should == 15
      fab.ap(Bassline::Nothing.new).ap(Bassline::Just.new(5)).class.name.should == Bassline::Nothing.name
      fab.ap(Bassline::Just.new(10)).ap(Bassline::Nothing.new).class.name.should == Bassline::Nothing.name
    end
  end

  describe "when either's ap is invoked" do
    it "should hold to identity: forall a . a == pure(identity).ap(a)" do
      id = ->(a) {a}

      x = Bassline::Right.new(10)
      x.get.should == Bassline::Either.pure(id).ap(x).get

      y = Bassline::Left.new(10)
      y.get.should == Bassline::Either.pure(id).ap(y).get
    end

    it "should hold to composition: forall af,ag,a . af.ap(ag.ap(a)) == pure(compose).ap(af).ap(ag).ap(a)" do
      compose = ->(a,b){->(x){a.(b.(x))}}

      af = Bassline::Right.new(->(a){a+4})
      ag = Bassline::Right.new(->(a){a+6})
      a = Bassline::Right.new(5)
      af.ap(ag.ap(a)).get.should == Bassline::Either.pure(compose).ap(af).ap(ag).ap(a).get

      af = Bassline::Left.new(->(a){a+4})
      ag = Bassline::Right.new(->(a){a+6})
      a = Bassline::Right.new(5)
      af.ap(ag.ap(a)).get.should == Bassline::Either.pure(compose).ap(af).ap(ag).ap(a).get

      af = Bassline::Right.new(->(a){a+4})
      ag = Bassline::Left.new(->(a){a+6})
      a = Bassline::Right.new(5)
      af.ap(ag.ap(a)).get.should == Bassline::Either.pure(compose).ap(af).ap(ag).ap(a).get

      af = Bassline::Right.new(->(a){a+4})
      ag = Bassline::Right.new(->(a){a+6})
      a = Bassline::Left.new(5)
      af.ap(ag.ap(a)).get.should == Bassline::Either.pure(compose).ap(af).ap(ag).ap(a).get

      af = Bassline::Left.new(->(a){a+4})
      ag = Bassline::Left.new(->(a){a+6})
      a = Bassline::Right.new(5)
      af.ap(ag.ap(a)).get.should == Bassline::Either.pure(compose).ap(af).ap(ag).ap(a).get

      af = Bassline::Left.new(->(a){a+4})
      ag = Bassline::Right.new(->(a){a+6})
      a = Bassline::Left.new(5)
      af.ap(ag.ap(a)).get.should == Bassline::Either.pure(compose).ap(af).ap(ag).ap(a).get

      af = Bassline::Right.new(->(a){a+4})
      ag = Bassline::Left.new(->(a){a+6})
      a = Bassline::Left.new(5)
      af.ap(ag.ap(a)).get.should == Bassline::Either.pure(compose).ap(af).ap(ag).ap(a).get

      af = Bassline::Left.new(->(a){a+4})
      ag = Bassline::Left.new(->(a){a+6})
      a = Bassline::Left.new(5)
      af.ap(ag.ap(a)).get.should == Bassline::Either.pure(compose).ap(af).ap(ag).ap(a).get
    end

    it "should hold to homomorphism: forall f a . pure(f).ap(pure(a)) == pure(f(a))" do
      f = ->(a){a+20}
      a = 10
      Bassline::Either.pure(f).ap(Bassline::Either.pure(10)).get.should == Bassline::Either.pure(f.(a)).get
    end

    it "should hold to interchange: forall af a . af.ap(pure(a)) == pure(->(f) {f.(a)}).ap(af)" do
      f = ->(a){a+10}
      a = 30
      Bassline::Right.new(f).ap(Bassline::Either.pure(a)).get.should == Bassline::Either.pure(->(g){g.(a)}).ap(Bassline::Right.new(f)).get
      Bassline::Left.new(f).ap(Bassline::Either.pure(a)).get.should == Bassline::Either.pure(->(g){g.(a)}).ap(Bassline::Left.new(f)).get
    end

    it "should be the same as fmap for all f,x: pure(f).ap(x) == x.fmap(f)" do
      f = ->(a) {a+5}

      x = Bassline::Right.new(20)
      Bassline::Either.pure(f).ap(x).get.should == x.fmap(f).get

      y = Bassline::Left.new(20)
      Bassline::Either.pure(f).ap(y).get.should == y.fmap(f).get
    end

    it "should accumulate errors when the type of e responds to concat" do
      result = Bassline::Either.pure(->(a,b,c){"test"}).ap(Bassline::Left.new ["error1"]).ap(Bassline::Left.new ["error2"]).ap(Bassline::Left.new ["error3"]).get
      result.should == ["error1","error2","error3"]
    end
  end
end
