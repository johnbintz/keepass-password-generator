require 'spec_helper'

describe KeePass::Random do
  
  describe "#random_number" do
    
    it "should use ActiveSupport::SecureRandom" do
      ActiveSupport::SecureRandom.should_receive(:random_number).once.with(12)
      described_class.random_number(12)
    end

    it "should accept default argument" do
      ActiveSupport::SecureRandom.should_receive(:random_number).with(0)
      described_class.random_number
    end
    
  end
  
  describe "#sample_array" do
    
    it "should call random_number with the array size" do
      described_class.should_receive(:random_number).with(6).and_return(3)
      described_class.sample_array(%w(a b c d e f)).should == 'd'
    end
    
    it "should return expected values for deterministic random number" do
      described_class.stub(:random_number) { |arg| 0 }
      described_class.sample_array(%w(a b c)).should == 'a'
      described_class.sample_array(%w(b a c)).should == 'b'
      described_class.sample_array(%w(c b a)).should == 'c'
    end
    
  end
  
  describe "#shuffle_array" do

    it "should call random_number with no parameters" do
      described_class.should_receive(:random_number).with().at_least(5).times.and_return(0.5)
      described_class.shuffle_array(%w(a b c d e))
    end
    
    it "should return the same elements" do
      described_class.stub(:random_number) { 0.5 }
      described_class.shuffle_array(%w(a b c d e)).sort.should == %w(a b c d e)
    end

  end
  
end
