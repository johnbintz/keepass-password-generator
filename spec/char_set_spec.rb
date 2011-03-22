require 'spec_helper'

describe KeePass::Password::CharSet do
  
  describe "#add_from_strings" do
    
    it "should add from multiple arguments" do
      subject.add_from_strings('abc', 'cde', 'QQ')
      subject.should == Set.new(%w(a b c d e Q))
    end
    
  end
  
  describe "#add_from_char_set_id" do
    
    it "should add the digits" do
      subject.add_from_char_set_id('d')
      subject.should == Set.new('0'..'9')
    end

    it "should support chaining" do
      subject.add_from_char_set_id('l').add_from_char_set_id('u')
      subject.should == (Set.new('a'..'z') + Set.new('A'..'Z'))
    end
    
    it "should allow x with default mapping" do
      subject.add_from_char_set_id('x')
      subject.should include(0x7f.chr)
    end
    
    it "should raise an error with ASCII mapping" do
      subject.mapping = KeePass::Password::CharSet::ASCII_MAPPING
      expect { subject.add_from_char_set_id('x') }.to raise_error(KeePass::Password::InvalidCharSetIDError)
    end
    
  end
  
end
