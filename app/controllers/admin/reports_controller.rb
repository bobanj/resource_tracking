class Admin::ReportsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  def index
  end

  def show
    report_class = "Reports::#{params[:id]}".constantize
    rep = report_class.new

    send_data rep.csv,
              :type => 'text/csv; charset=iso-8859-1; header=present',
              :disposition => "attachment; filename=#{params[:id]}.csv"
  end
end
