class PolicyMaker::TargetReportsController < ApplicationController

  def index
    @codes = Code.for_activities.roots
  end

end
