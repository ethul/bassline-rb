require "spec_helper"

describe Bassline::Kleisli do
  let(:id){->a {a}}
  let(:compose){->(x,y){->(z){x.(y.(z))}}}
  let(:a){10}
  let(:b){20}
  let(:nothing){Nothing.new}
  let(:fb){Kleisli.new ->a {Just.new(b)}}
  let(:mb){Kleisli.new ->a {Bassline::Just.new(b)}}

  describe "#and_then" do
    let(:k1){Kleisli.new ->a {Just.new(a+"one")}}
    let(:k2){Kleisli.new ->a {Just.new(a+"two")}}
    specify{k1.and_then(k2).run("").get.should == "onetwo"}
  end

  describe "#and_then_k" do
    let(:k1){Kleisli.new ->a {Just.new(a+"one")}}
    let(:k2){->a {Just.new(a+"two")}}
    specify{k1.and_then_k(k2).run("").get.should == "onetwo"}
  end

  describe "#compose" do
    let(:k1){Kleisli.new ->a {Just.new(a+"one")}}
    let(:k2){Kleisli.new ->a {Just.new(a+"two")}}
    specify{k1.compose(k2).run("").get.should == "twoone"}
  end

  describe "#compose_k" do
    let(:k1){Kleisli.new ->a {Just.new(a+"one")}}
    let(:k2){->a {Just.new(a+"two")}}
    specify{k1.compose_k(k2).run("").get.should == "twoone"}
  end

  describe "#fmap" do
    context "identity: forall a . fa(a) == fa(a).fmap(identity)" do
      specify{fb.run(a).get.should == fb.fmap(id).run(a).get}
    end
    context "composition: forall a,f,g . fa(a).fmap(f compose g) = fa(a).fmap(g).fmap(f)" do
      let(:f){->a {a+5}}
      let(:g){->a {a+10}}
      specify{fb.fmap(compose.(f,g)).run(a).get.should == fb.fmap(g).fmap(f).run(a).get}
    end
  end

  describe "#fmap_k" do
    context "when a Just is mapped to a Nothing" do
      specify{fb.fmap_k(->_ {nothing}).run(a).should be_instance_of nothing.class}
    end
  end

  describe "#bind" do
    context "left identity: forall f,a . f(a) == return(a).bind(f)" do
      let(:f){->a {Kleisli.new ->a {Bassline::Just.new(a)}}}
      specify{f.(a).run(a).get.should == mb.bind(f).run(a).get}
    end
    context "right identity: forall ma . ma == ma.bind(x -> return(x))" do
      specify{
        mb.run(a).get.should ==
        mb.bind(->x {Kleisli.return(Maybe.return(x))}).run(a).get
      }
    end
    context "associativity: forall ma,f,g . (ma.bind(f)).bind(g) == ma.bind(x -> f(x).bind(g))" do
      let(:f){->a {Kleisli.new ->a {Just.new(a+10)}}}
      let(:g){->a {Kleisli.new ->a {Just.new(a+30)}}}
      specify{mb.bind(f).bind(g).run(a).get.should == mb.bind(->x {f.(x).bind(g)}).run(a).get}
    end
  end

  describe "#bind_k" do
    context "when a function returns a nothing instance" do
      let(:f){->_ {nothing}}
      specify{mb.bind_k(f).run(a).should be_instance_of nothing.class}
    end
  end
end
