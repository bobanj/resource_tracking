class StaticPageController < ApplicationController
  skip_before_filter :load_help

  def index
    @user_session = UserSession.new
  end

  def show
    #TODO add authorization for the various dashboards
    render :action => params[:page]
  end
end

