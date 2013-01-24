require "spec_helper"
require "bassline/global"

describe Bassline do
  context "when global is required" do
    specify{Maybe.should == Bassline::Maybe}
    specify{Just.should == Bassline::Just}
    specify{Nothing.should == Bassline::Nothing}
    specify{Either.should == Bassline::Either}
    specify{Left.should == Bassline::Left}
    specify{Right.should == Bassline::Right}
    specify{Kleisli.should == Bassline::Kleisli}
  end
end
