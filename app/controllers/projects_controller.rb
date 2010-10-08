class ProjectsController < ApplicationController

  authorize_resource
  before_filter :check_user_has_data_response, :load_model_help

  def index
  end

  private
  def load_model_help
    @model_help = ModelHelp.find_by_model_name("Project")
  end
end
