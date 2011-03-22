require 'spec_helper'

describe KeePass::Password::Generator do

  def char_set(*ids)
    char_set = KeePass::Password::CharSet.new
    ids.each { |id| char_set.add_from_char_set_id(id) }
    char_set
  end
  
  subject { described_class.new(pattern, options) }
  let(:options) { { } }
  let(:random_class) { KeePass::Random }
  
  describe "pattern 'h{10}' (40-bit WEP key)" do
  
    let(:pattern) { 'h{10}' }

    its(:pattern) { should == 'h{10}' }
    its(:permute) { should be_true }
    its(:char_sets) { should have(10).items }

    it "should generate 10 hex digits " do
      random_class.should_receive(:sample_array) do |array|
        array.sort.should == char_set('h').to_a.sort
        '0'
      end.exactly(10).times
      random_class.should_receive(:shuffle_array) do |array|
        array.sort
      end.once
      subject.generate.should == '0000000000'
    end
  
  end
  
  describe "pattern 'HH\-HH\-HH\-HH\-HH\-HH', :permute => false" do
    
    let(:pattern) { 'HH\-HH\-HH\-HH\-HH\-HH' }
    let(:options) { { :permute => false } }
  
    its(:pattern) { should == 'HH\-HH\-HH\-HH\-HH\-HH' }
    its(:permute) { should be_false }
    its(:char_sets) { should have(17).items }
    
    it "should generate a MAC address" do
      random_class.should_receive(:sample_array) do |array|
        if array == ['-']
          '-'
        else
          array.sort.should == char_set('H').to_a.sort
          '0'
        end
      end.exactly(17).times
      random_class.should_not_receive(:shuffle_array)
      subject.generate.should == '00-00-00-00-00-00'
    end

  end

  describe "pattern 'uullA{6}'" do
    
    let(:pattern) { 'uullA{6}' }
  
    its(:pattern) { should == 'uullA{6}' }
    its(:permute) { should be_true }
    its(:char_sets) { should have(10).items }
    
    it "should generate a 10-character alphanumeric password" do
      random_class.should_receive(:sample_array) do |array|
        array.sort.first
      end.exactly(10).times
      random_class.should_receive(:shuffle_array) do |array|
        array.sort
      end.once
      subject.generate.should == '000000AAaa'
    end
    
  end
  
  describe "pattern '[As]{20}', :remove_lookalikes => true" do
    
    let(:pattern) { '[As]{20}' }
    let(:options) { { :remove_lookalikes => true } }
    
    its(:pattern) { should == '[As]{20}' }
    its(:permute) { should be_true }
    its(:char_sets) { should have(20).items }
    
    it "should generate a 20-character password" do
      test_set = (char_set('A', 's') - Set.new(%w(O 0 l 1 I |))).to_a.sort
      i = 0
      random_class.should_receive(:sample_array) do |array|
        array.sort.should == test_set
        result = array.sort[i]
        i += 1
        result
      end.exactly(20).times
      random_class.should_receive(:shuffle_array) do |array|
        array.sort
      end.once
      subject.generate.should == '!"#$%&\'()*+,-./23456'
    end
    
  end
  
  describe "pattern '[\\I\\|]{3}', :remove_lookalikes => true" do
    
    let(:pattern) { '[\I\|]{3}' }
    let(:options) { { :remove_lookalikes => true } }
    
    it "should raise an error" do
      expect { subject }.to raise_error(KeePass::Password::InvalidPatternError)
    end

  end
  
end
