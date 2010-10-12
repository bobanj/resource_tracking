class ProjectsController < ApplicationController

  # Sortable table
  sortable_attributes :name, :description, :budget, :spend, :organization => "organizations.name"

  authorize_resource
  before_filter :check_user_has_data_response
  #before_filter :load_model_help
  before_filter do |controller|
    controller.send(:load_model_help) if controller.request.format.html?
  end

  # Inherited Resources
  inherit_resources

  # Respond type
  respond_to :html, :js, :json

  def index
    @projects = current_user.current_data_response.projects.matching(params[:q]).find(:all, :order => sort_order(:default => 'ascending'), :include => {:data_response => :responding_organization})

    respond_to do |format|
      format.html
      format.js { render :partial => 'table', :locals => {:projects => @projects} }
    end
  end

  def search
    respond_to do |format|
      format.html
      format.js { render :action => "search", :layout => false }
    end
  end

  def new
    @project = Project.new
    @project.location_ids = [] # cut on db selects
    respond_to do |format|
      format.html
      format.js { render :partial => "form", :locals => {:project => @project } }
    end
  end

  def show
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html
      format.js   { render :partial => 'row', :locals => {:project => resource} }
      format.json { render :json => @project }
    end
  end

  def edit
    @project = Project.find(params[:id], :include => :locations) # eager load locations
    respond_to do |format|
      format.html
      format.js { render :partial => "form", :locals => {:project => @project } }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to projects_url }
      failure.html { render :action => "new" }
      success.js   { render :partial => "row",  :locals => {:project => resource} }
      failure.js   { render :partial => "form", :locals => {:project => resource}, :status => :partial_content } # :partial_content => 206
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to projects_url }
      failure.html { render :action => "edit" }
      success.js   { render :partial => "row",  :locals => {:project => resource} }
      failure.js   { render :partial => "form", :locals => {:project => resource}, :status => :partial_content } # :partial_content => 206
      success.json { render :nothing =>  true }
      failure.json { render :nothing =>  true }
    end
  end

  def destroy
    destroy! do |success|
      success.html { redirect_to projects_url }
      success.js   { render :nothing => true }
    end
  end

  def delete
    @project = Project.find(params[:id])
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
