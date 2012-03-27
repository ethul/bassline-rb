require "spec_helper"
require "bassline/global"

describe "when global is required" do
  it "should access Bassline::Maybe in the global namespace" do
    Maybe.should == Bassline::Maybe
  end
  it "should access Bassline::Just in the global namespace" do
    Just.should == Bassline::Just
  end
  it "should access Bassline::Nothing in the global namespace" do
    Nothing.should == Bassline::Nothing
  end
  it "should access Bassline::Either in the global namespace" do
    Either.should == Bassline::Either
  end
  it "should access Bassline::Left in the global namespace" do
    Left.should == Bassline::Left
  end
  it "should access Bassline::Right in the global namespace" do
    Right.should == Bassline::Right
  end
end
