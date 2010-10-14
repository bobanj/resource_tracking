class ReportsController < ApplicationController
  before_filter :require_user

  def index
  end

  def show
    report_class = "Reports::#{params[:id]}".constantize
    report = report_class.new(current_user)

    send_data report.csv,
              :type => 'text/csv; charset=iso-8859-1; header=present',
              :disposition => "attachment; filename=#{params[:id].underscore}.csv"
  end
end
