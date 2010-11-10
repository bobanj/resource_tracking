require File.dirname(__FILE__) + '/../../spec_helper'

describe Reports::Pie::DataResponsePie do

  it "should initialize proper object" do
    dr = Factory(:data_response)
    dr_pie_report = Reports::Pie::DataResponsePie.new(dr, 'CodingBudget', 'Mtef')
    dr_pie_report.should be_an_instance_of(Reports::Pie::DataResponsePie)
  end

  describe "CodingBudget" do
    describe "Mtef" do
      it "should return empty csv string" do
        dr = Factory(:data_response)
        dr_pie_report = Reports::Pie::DataResponsePie.new(dr, 'CodingBudget', 'Mtef')
        dr_pie_report.should be_an_instance_of(Reports::Pie::DataResponsePie)
        dr_pie_report.to_csv.should == ""
      end
    end
  end

end
