class PolicyMaker::TargetReportsController < ApplicationController

  def index
    @codes = Code.for_activities.roots
  end

  def show
    @code = Code.find(params[:id])
    render :layout => "iframe"
  end
end
