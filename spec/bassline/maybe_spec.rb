require "spec_helper"

describe Bassline::Maybe do
  let(:value){10}
  let(:or_value){"a"}

  describe "when the Maybe is a Just" do
    subject{Bassline::Just.new value}
    describe "#get_or" do
      it "should return the value of the Just" do
        subject.get_or(or_value).should == value
      end
    end
  end

  describe "when the Maybe is a Nothing" do
    subject{Bassline::Nothing.new}
    describe "#get_or" do
      it "should return the or" do
        subject.get_or(or_value).should == or_value
      end
    end
  end
end
