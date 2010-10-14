class FundingSourcesController < ApplicationController

  # Authorization
  authorize_resource :class => FundingFlow

  # Filters
  before_filter :check_user_has_data_response
  before_filter :load_data_response
  before_filter do |controller|
    controller.send(:load_model_help) if controller.request.format.html?
  end

  # Sortable table
  sortable_attributes :budget, :spend, :project => "projects.name", :from => "organizations.name"

  def index
    @funding_sources = @current_data_response.funding_flows.sources.matching(params[:q], 'sources').find(:all, :include => [:data_response, :project, :from], :order => sort_order(:default => 'ascending'))
    respond_to do |format|
      format.html
      format.js { render :partial => 'table', :locals => {:funding_sources => @funding_sources } }
    end
  end

  def search
    respond_to do |format|
      format.html { render :template => "shared/_search" }
      format.js   { render :partial => "shared/search", :layout => false }
    end
  end

  def new
    @funding_source = FundingFlow.new
    respond_to do |format|
      format.html
      format.js { render :partial => "form", :locals => {:funding_source => @funding_source } }
    end
  end

  def show
    @funding_source = @current_data_response.funding_flows.find(params[:id])
    respond_to do |format|
      format.html
      format.js   { render :partial => 'row', :locals => {:funding_source => @funding_source } }
      format.json { render :json => @funding_source }
    end
  end

  def edit
    @funding_source = @current_data_response.funding_flows.find(params[:id])
    respond_to do |format|
      format.html
      format.js { render :partial => "form", :locals => {:funding_source => @funding_source } }
    end
  end

  def create
    @funding_source = @current_data_response.funding_flows.new(params[:funding_flow].merge!({:self_provider_flag => 0, :to => @current_data_response.responding_organization}))

    if @funding_source.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Funding source was successfully created."
          redirect_to funding_sources_url
        end
        format.js   { render :partial => "row",  :locals => {:funding_source => @funding_source} }
      end
    else
      respond_to do |format|
        format.html { render :action => "new" }
        format.js   { render :partial => "form", :locals => {:funding_source => @funding_source}, :status => :partial_content } # :partial_content => 206
      end
    end
  end

  def update
    @funding_source = @current_data_response.funding_flows.find(params[:id])
    
    if @funding_source.update_attributes(params[:funding_flow])
      respond_to do |format|
        format.html do
          flash[:notice] = "Funding source was successfully updated."
          redirect_to funding_sources_url
        end
        format.js   { render :partial => "row",  :locals => {:funding_source => @funding_source} }
        format.json { render :nothing =>  true }
      end
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.js   { render :partial => "form", :locals => {:funding_source => @funding_source}, :status => :partial_content } # :partial_content => 206
        format.json { render :nothing =>  true }
      end
    end
  end

  def destroy
    @funding_source = @current_data_response.funding_flows.find(params[:id])
    @funding_source.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = "Funding source was successfully deleted."
        redirect_to funding_sources_url
      end
      format.js   { render :nothing => true }
    end
  end

  def delete
    @funding_source = @current_data_response.funding_flows.sources.find(params[:id])
  end

  private
  def load_model_help
    @model_help = ModelHelp.find_by_model_name("FundingSource")
  end
end
