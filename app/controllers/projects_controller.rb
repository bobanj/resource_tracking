class ProjectsController < ApplicationController

  authorize_resource
  before_filter :check_user_has_data_response, :load_model_help

  # Inherited Resources
  inherit_resources

  # Respond type
  respond_to :html, :js

  def index
    @projects = current_user.current_data_response.projects.find(:all, :order => "created_at DESC")
  end

  def new
    @project = Project.new
    @project.location_ids = [] #save on db selects
  end

  def edit
    @project = Project.find(params[:id], :include => :locations) # eager load locations
  end

  def create
    create! do |success, failure|
      success.html { redirect_to projects_url }
      failure.html { render :action => "new" }
    end
  end

  def update
    #raise params[:project].to_yaml
    update! do |success, failure|
      success.html { redirect_to projects_url }
      failure.html { render :action => "edit" }
    end
  end


  protected
  def begin_of_association_chain
    current_user.current_data_response
  end

  private
  def load_model_help
    @model_help = ModelHelp.find_by_model_name("Project")
  end
end
