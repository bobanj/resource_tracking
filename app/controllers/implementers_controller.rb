class ImplementersController < ApplicationController

  # Authorization
  authorize_resource :class => FundingFlow

  # Filters
  before_filter :check_user_has_data_response
  before_filter :load_data_response
  before_filter do |controller|
    controller.send(:load_model_help) if controller.request.format.html?
  end

  # Sortable table
  sortable_attributes :budget, :spend, :project => "projects.name", :to => "organizations.name"

  def index
    @implementers = @current_data_response.funding_flows.implementers(current_user.organization).matching(params[:q], 'implementers').find(:all, :include => [:data_response, :project, :to], :order => sort_order(:default => 'ascending'))
    respond_to do |format|
      format.html
      format.js { render :partial => 'table', :locals => {:implementers => @implementers } }
    end
  end

  def search
    respond_to do |format|
      format.html { render :template => "shared/_search", :locals => {:url => implementers_path} }
      format.js   { render :partial => "shared/search", :locals => {:url => implementers_path}, :layout => false }
    end
  end

  def new
    @implementer = FundingFlow.new
    respond_to do |format|
      format.html
      format.js { render :partial => "form", :locals => {:implementer => @implementer } }
    end
  end

  def show
    @implementer = @current_data_response.funding_flows.find(params[:id])
    respond_to do |format|
      format.html
      format.js   { render :partial => 'row', :locals => {:implementer => @implementer } }
      format.json { render :json => @implementer }
    end
  end

  def edit
    @implementer = @current_data_response.funding_flows.find(params[:id])
    respond_to do |format|
      format.html
      format.js { render :partial => "form", :locals => {:implementer => @implementer } }
    end
  end

  def create
    @implementer = @current_data_response.funding_flows.new(params[:funding_flow].merge!({:self_provider_flag => 1, :from => @current_data_response.responding_organization}))

    if @implementer.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Implementer was successfully created."
          redirect_to implementers_url
        end
        format.js   { render :partial => "row",  :locals => {:implementer => @implementer} }
      end
    else
      respond_to do |format|
        format.html { render :action => "new" }
        format.js   { render :partial => "form", :locals => {:implementer => @implementer}, :status => :partial_content } # :partial_content => 206
      end
    end
  end

  def update
    @implementer = @current_data_response.funding_flows.find(params[:id])
    
    if @implementer.update_attributes(params[:funding_flow])
      respond_to do |format|
        format.html do
          flash[:notice] = "Implementer was successfully updated."
          redirect_to implementers_url
        end
        format.js   { render :partial => "row",  :locals => {:implementer => @implementer} }
        format.json { render :nothing =>  true }
      end
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.js   { render :partial => "form", :locals => {:implementer => @implementer}, :status => :partial_content } # :partial_content => 206
        format.json { render :nothing =>  true }
      end
    end
  end

  def destroy
    @implementer = @current_data_response.funding_flows.find(params[:id])
    @implementer.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = "Implementer was successfully deleted."
        redirect_to implementers_url
      end
      format.js   { render :nothing => true }
    end
  end

  def delete
    @implementer = @current_data_response.funding_flows.find(params[:id])
  end

  private
  def load_model_help
    @model_help = ModelHelp.find_by_model_name("Provider")
  end
end
