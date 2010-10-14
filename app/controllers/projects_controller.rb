class ProjectsController < ApplicationController

  # Authorization
  authorize_resource

  # Filters
  before_filter :check_user_has_data_response
  before_filter :load_data_response
  before_filter do |controller|
    controller.send(:load_model_help) if controller.request.format.html?
  end

  # Sortable table
  sortable_attributes :name, :description, :budget, :spend, :organization => "organizations.name"

  def index
    @projects = @current_data_response.projects.matching(params[:q]).find(:all, :order => sort_order(:default => 'ascending'), :include => {:data_response => :responding_organization})
    respond_to do |format|
      format.html
      format.js { render :partial => 'table', :locals => {:projects => @projects} }
    end
  end

  def search
    respond_to do |format|
      format.html { render :template => "shared/_search", :locals => {:url => projects_path} }
      format.js   { render :partial => "shared/search", :locals => {:url => projects_path}, :layout => false }
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
    @project = @current_data_response.projects.find(params[:id])
    respond_to do |format|
      format.html
      format.js   { render :partial => 'row', :locals => {:project => @project} }
      format.json { render :json => @project }
    end
  end

  def edit
    @project = @current_data_response.projects.find(params[:id], :include => :locations) # eager load locations
    respond_to do |format|
      format.html
      format.js { render :partial => "form", :locals => {:project => @project } }
    end
  end

  def create
    @project = @current_data_response.projects.new(params[:project])

    if @project.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Project was successfully created."
          redirect_to projects_url
        end
        format.js   { render :partial => "row",  :locals => {:project => @project} }
      end
    else
      respond_to do |format|
        format.html { render :action => "new" }
        format.js   { render :partial => "form", :locals => {:project => @project}, :status => :partial_content } # :partial_content => 206
      end
    end
  end

  def update
    @project = @current_data_response.projects.find(params[:id])

    if @project.update_attributes(params[:project])
      respond_to do |format|
        format.html do
          flash[:notice] = "Project was successfully updated."
          redirect_to projects_url
        end
        format.js   { render :partial => "row",  :locals => {:project => @project} }
        format.json { render :nothing =>  true }
      end
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.js   { render :partial => "form", :locals => {:project => @project}, :status => :partial_content } # :partial_content => 206
        format.json { render :nothing =>  true }
      end
    end
  end

  def destroy
    @project = @current_data_response.projects.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = "Project was successfully deleted."
        redirect_to projects_url
      end
      format.js   { render :nothing => true }
    end

  end

  def delete
    @project = @current_data_response.projects.find(params[:id])
  end

  private
  def load_model_help
    @model_help = ModelHelp.find_by_model_name("Project")
  end
end
