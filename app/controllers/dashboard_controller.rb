class DashboardController < ApplicationController
  before_filter :require_user

  def index
    @data_requests_unfulfilled = DataRequest.unfulfilled(current_user.organization)
    @data_responses = current_user.data_responses
  end
end
