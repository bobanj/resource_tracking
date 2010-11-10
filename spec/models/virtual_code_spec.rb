require File.dirname(__FILE__) + '/../spec_helper'

describe VirtualCode do
  describe "creating a Virtual Code" do
    subject { Factory(:virtual_code) }    
    it { should be_valid }
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).scoped_to(:virtual_code_group_id) }
    it { should validate_presence_of(:virtual_code_group) }
    it { should belong_to :virtual_code_group }
    it { should have_many(:codes).through(:virtual_code_codes) }
  end
  
  describe "getting totals for all related Codes" do
    before :each do
      @activity        = Factory(:activity, :budget => 10.00)
      @code            = Factory(:code)
      @code_assignment = Factory(:coding_budget, 
                                :activity => @activity,
                                :code     => @code,
                                :amount   => 10.00,
                                :cached_amount => 10.00)
      @vcode_group     = Factory(:virtual_code_group) #, :user => ?)
      @vcode           = Factory(:virtual_code, 
                                :codes              => [@code],
                                :virtual_code_group => @vcode_group)
    end
    
    it "should equal zero if no codes" do
      vcode1           = Factory(:virtual_code, 
                                :codes              => [],
                                :virtual_code_group => @vcode_group)
      vcode1.codes.should have(0).codes
      vcode1.budget_total().to_f.should == 0.00
    end
    
    it "should equal a single total if only one activity coding" do
      @vcode.should be_valid
      @vcode.codes.should have(1).code
      # debugger
      @vcode.budget_total().to_f.should == 10.00
    end

    describe "multiple codings" do
      
      before :each do
        @activity.budget = 30.00
        @activity.save!
        @code2            = Factory(:code)
        @code_assignment2 = Factory(:coding_budget, 
                                  :activity      => @activity,
                                  :code          => @code2,
                                  :amount        => 20.00,
                                  :cached_amount => 20.00)

        @vcode.codes << @code2
        @vcode.save!
      end
      
      it "should sum multiple activity codings" do
        @vcode.should be_valid
        @vcode.codes.should have(2).codes
        @vcode.budget_total().to_f.should == 30.00
      end
      
      it "should sum multiple activity codings & codes" do
        @code3            = Factory(:code)
        @code_assignment3 = Factory(:coding_budget, 
                                  :activity      => @activity,
                                  :code          => @code3,
                                  :amount        => 5.00,
                                  :cached_amount => 5.00)

        @vcode.codes << @code3
        @vcode.save!
        @vcode.should be_valid
        @vcode.codes.should have(3).codes
        @vcode.budget_total().to_f.should == 35.00
      end

    end
    
  end
  
end

