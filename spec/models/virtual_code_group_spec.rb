require File.dirname(__FILE__) + '/../spec_helper'

describe VirtualCodeGroup do
  describe "creating a Virtual Code Group" do
    subject { Factory(:virtual_code_group) }    
    it { should be_valid }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:user) }
    it { should belong_to :user }
    it { should have_many :virtual_codes }
  end
  
end
