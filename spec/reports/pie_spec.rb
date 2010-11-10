require File.dirname(__FILE__) + '/../spec_helper'

describe Reports::Pie do

  it "should initialize proper object" do
    pie_report = Reports::Pie.new
    pie_report.should be_an_instance_of(Reports::Pie)
  end

end
