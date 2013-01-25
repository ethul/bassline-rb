require "spec_helper"

describe Bassline::Maybe do
  let(:id){->a {a}}
  let(:compose){->x,y {->z {x.(y.(z))}}}
  let(:f){->a {a+5}}
  let(:g){->a {a+10}}
  let(:a){10}
  let(:b){4}

  describe "#fmap" do
    let(:fa){Just.new(a)}
    context "identity: forall a . maybe(a) == maybe(a).fmap(identity)" do
      specify{fa.get.should == fa.fmap(id).get}
    end
    context "composition: forall a,f,g . maybe(a).fmap(f compose g) = maybe(a).fmap(g).fmap(f)" do
      specify{fa.fmap(compose.(f,g)).get.should == fa.fmap(g).fmap(f).get}
    end
  end

  describe "#ap" do
    let(:fa){Just.new(a)}
    let(:fb){Nothing.new}
    let(:pure){->a {Maybe.pure(a)}}
    context "identity: forall a . a == pure(identity).ap(a)" do
      specify{fa.get.should == pure.(id).ap(fa).get}
      specify{fb.should be_instance_of pure.(id).ap(fb).class}
    end
    context "composition: forall af,ag,a . af.ap(ag.ap(a)) == pure(compose).ap(af).ap(ag).ap(a)" do
      let(:fa){Just.new(f)}
      let(:fb){Nothing.new}
      let(:fc){Just.new(a)}
      let(:fd){Nothing.new}
      let(:perms_ff){[fa, fb].repeated_permutation(2).to_a}
      specify {
        [fc, fd].each {|a|
          perms_ff.each {|af,ag|
            x = af.ap(ag.ap(a))
            y = pure.(compose).ap(af).ap(ag).ap(a)
            if x.respond_to?(:get)
              x.get.should == y.get
            else
              x.should be_instance_of y.class
            end
          }
        }
      }
    end
    context "homomorphism: forall f a . pure(f).ap(pure(a)) == pure(f(a))" do
      specify{pure.(f).ap(pure.(a)).get.should == pure.(f.(a)).get}
    end
    context "interchange: forall af a . af.ap(pure(a)) == pure(->(f) {f.(a)}).ap(af)" do
      let(:fa){Just.new(f)}
      let(:fb){Nothing.new}
      specify{fa.ap(pure.(a)).get.should == pure.(->g {g.(a)}).ap(fa).get}
      specify{fb.ap(pure.(a)).should be_instance_of pure.(->g {g.(a)}).ap(fb).class}
    end
    context "fmap for all f,x: pure(f).ap(x) == x.fmap(f)" do
      let(:fa){Just.new(20)}
      let(:fb){Nothing.new}
      specify{pure.(f).ap(fa).get.should == fa.fmap(f).get}
      specify{pure.(f).ap(fb).should be_instance_of fb.fmap(f).class}
    end
    context "when basic use cases are applied" do
      let(:fab){Just.new(->a {->b {a+b}})}
      specify{fab.ap(Just.new(10)).ap(Just.new(5)).get.should == 15}
      specify{fab.ap(Nothing.new).ap(Just.new(5)).should be_instance_of Nothing}
      specify{fab.ap(Just.new(10)).ap(Nothing.new).should be_instance_of Nothing}
    end
  end

  describe "#bind" do
    let(:f){->a {Bassline::Just.new(a + 10)}}
    let(:g){->a {Bassline::Just.new(a + 30)}}
    let(:ret){->a {Maybe.return(a)}}
    let(:fa){Just.new(a)}
    let(:fb){Nothing.new}
    context "left identity: forall f,a . f(a) == return(a).bind(f)" do
      specify{f.(a).get.should == fa.bind(f).get}
    end
    context "right identity: forall ma . ma == ma.bind(x -> return(x))" do
      specify{fa.get.should == fa.bind(->x {ret.(x)}).get}
      specify{fb.should be_instance_of fb.bind(->x {ret.(x)}).class}
    end
    context "associativity: forall ma,f,g . (ma.bind(f)).bind(g) == ma.bind(x -> f(x).bind(g))" do
      specify{fa.bind(f).bind(g).get.should == fa.bind(->x {f.(x).bind(g)}).get}
      specify{fb.bind(f).bind(g).should be_instance_of fb.bind(->x {f.(x).bind(g)}).class}
    end
  end
end
