# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < AuthlogicController
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
  protect_from_forgery :only => [:create, :update, :destroy] # Active Scaffold fix
  filter_parameter_logging :password, :password_confirmation

  include ApplicationHelper

  # Sortable table
  include SortableTable::App::Controllers::ApplicationController

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to do that"
    redirect_to login_url
  end

  private
  def check_user_has_data_response
    unless current_user.current_data_response || current_user.role?(:admin)
      flash[:warning] = "Please first click on one of the links underneath \"Data Requests to Fulfill\" to continue. We will remember which data request you were responding to the next time you login, so you won't see this message again."
      #TODO email the file and have someone get back to helping them
      redirect_to user_dashboard_path(current_user)
    end
  end

  def load_data_response
    @current_data_response = current_user.try(:current_data_response)
  end
end
