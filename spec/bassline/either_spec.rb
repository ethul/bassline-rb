require "spec_helper"

describe Bassline::Either do
  let(:id){->a {a}}
  let(:compose){->x,y {->z {x.(y.(z))}}}
  let(:f){->a {a+5}}
  let(:g){->a {a+10}}
  let(:a){10}
  let(:b){4}

  describe "#fmap" do
    let(:fa){Right.new(a)}
    let(:fb){Left.new(b)}
    context "identity: forall a . either(a) == either(a).fmap(identity)" do
      specify{fa.get.should == fa.fmap(id).get}
      specify{fb.get.should == fb.fmap(id).get}
    end
    context "composition: forall a,f,g . either(a).fmap(f compose g) = either(a).fmap(g).fmap(f)" do
      specify{fa.fmap(compose.(f, g)).get.should == fa.fmap(g).fmap(f).get}
      specify{fb.fmap(compose.(f, g)).get.should == fb.fmap(g).fmap(f).get}
    end
  end

  describe "#ap" do
    let(:pure){->a {Either.pure(a)}}
    let(:fa){Right.new(a)}
    let(:fb){Left.new(b)}
    let(:ff){Bassline::Right.new(f)}
    let(:fg){Bassline::Left.new(g)}
    context "identity: forall a . a == pure(identity).ap(a)" do
      specify{fa.get.should == pure.(id).ap(fa).get}
      specify{fb.get.should == pure.(id).ap(fb).get}
    end
    context "composition: forall af,ag,a . af.ap(ag.ap(a)) == pure(compose).ap(af).ap(ag).ap(a)" do
      let(:perms){[ff, fg].repeated_permutation(2).to_a}
      specify {
        [fa, fb].each {|a|
          perms.each {|af,ag|
            af.ap(ag.ap(a)).get.should == pure.(compose).ap(af).ap(ag).ap(a).get
          }
        }
      }
    end
    context "homomorphism: forall f a . pure(f).ap(pure(a)) == pure(f(a))" do
      specify{pure.(f).ap(pure.(10)).get.should == pure.(f.(a)).get}
    end
    context "interchange: forall af a . af.ap(pure(a)) == pure(->(f) {f.(a)}).ap(af)" do
      specify{ff.ap(pure.(a)).get.should == pure.(->g {g.(a)}).ap(ff).get}
      specify{fg.ap(pure.(a)).get.should == pure.(->g {g.(a)}).ap(fg).get}
    end
    context "fmap for all f,x: pure(f).ap(x) == x.fmap(f)" do
      specify{pure.(f).ap(fa).get.should == fa.fmap(f).get}
      specify{pure.(g).ap(fb).get.should == fb.fmap(g).get}
    end
    context "when the type of e responds to +" do
      specify{pure.(->a,b,c {}).ap(fb).ap(fb).ap(fb).get.should == b * 3}
    end
  end

  describe "#bind" do
    let(:ret){->a {Either.return(a)}}
    let(:f){->a {Bassline::Right.new(a + 10)}}
    let(:g){->b {Bassline::Left.new(b + 20)}}
    let(:fa){Right.new(a)}
    let(:fb){Left.new(b)}
    context "left identity: forall f,a . f(a) == return(a).bind(f)" do
      specify{f.(a).get.should == ret.(a).bind(f).get}
      specify{g.(b).get.should == ret.(b).bind(g).get}
    end
    context "right identity: forall ma . ma == ma.bind(x -> return(x))" do
      specify{fa.get.should == fa.bind(->a {ret.(a)}).get}
      specify{fb.get.should == fb.bind(->a {ret.(a)}).get}
    end
    context "associativity: forall ma,f,g . (ma.bind(f)).bind(g) == ma.bind(x -> f(x).bind(g))" do
      let(:perms){[f, g].repeated_permutation(2).to_a}
      specify{
        perms.each {|f,g|
          fa.bind(f).bind(g).get.should == fa.bind(->x {f.(x).bind(g)}).get
        }
      }
      specify{
        perms.each {|f,g|
          fb.bind(f).bind(g).get.should == fb.bind(->x {f.(x).bind(g)}).get
        }
      }
    end
  end
end
