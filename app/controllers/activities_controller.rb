class ActivitiesController < ActiveScaffoldController

  # Authorization
  authorize_resource

  # Filters
  before_filter :check_user_has_data_response
  before_filter :load_data_response
  before_filter do |controller|
    controller.send(:load_model_help) if controller.request.format.html?
  end

  # Sortable table
  sortable_attributes :name, :description, :budget, :spend, :organization => "organizations.name", :implementer => "implementers.name"

  def index
    @activities = @current_data_response.activities.roots.matching(params[:q]).find(:all, :order => sort_order(:default => 'ascending'), :joins => 'LEFT OUTER JOIN organizations as implementers ON activities.provider_id = implementers.id', :include => [{:data_response => :responding_organization}, :provider, :projects])
    respond_to do |format|
      format.html
      format.js { render :partial => 'table', :locals => {:activities => @activities} }
    end
  end

  def search
    respond_to do |format|
      format.html { render :template => "shared/_search", :locals => {:url => activities_path} }
      format.js   { render :partial => "shared/search", :locals => {:url => activities_path}, :layout => false }
    end
  end

  def new
    @activity = Activity.new
    @activity.location_ids = [] # cut on db selects
    respond_to do |format|
      format.html
      format.js { render :partial => "form", :locals => {:activity => @activity } }
    end
  end

  def show
    @activity = @current_data_response.activities.find(params[:id])
    respond_to do |format|
      format.html
      format.js   { render :partial => 'row', :locals => {:activity => resource} }
      format.json { render :json => @activity }
    end
  end

  def edit
    @activity = @current_data_response.activities.find(params[:id], :include => :locations) # eager load locations
    respond_to do |format|
      format.html
      format.js { render :partial => "form", :locals => {:activity => @activity } }
    end
  end

  def create
    @activity = @current_data_response.activities.new(params[:activity])

    if @activity.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Activity was successfully created."
          redirect_to activities_url
        end
        format.js   { render :partial => "row",  :locals => {:activity => @activity} }
      end
    else
      respond_to do |format|
        format.html { render :action => "new" }
        format.js   { render :partial => "form", :locals => {:activity => @activity}, :status => :partial_content } # :partial_content => 206
      end
    end
  end

  def update
    @activity = @current_data_response.activities.find(params[:id])

    if @activity.update_attributes(params[:activity])
      respond_to do |format|
        format.html do
          flash[:notice] = "Activity was successfully updated."
          redirect_to activities_url
        end
        format.js   { render :partial => "row",  :locals => {:activity => @activity} }
        format.json { render :nothing =>  true }
      end
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.js   { render :partial => "form", :locals => {:activity => @activity}, :status => :partial_content } # :partial_content => 206
        format.json { render :nothing =>  true }
      end
    end
  end

  def destroy
    @activity = @current_data_response.activities.find(params[:id])
    @activity.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = "Activity was successfully deleted."
        redirect_to activities_url
      end
      format.js   { render :nothing => true }
    end

  end

  def delete
    @activity = @current_data_response.activities.find(params[:id])
  end

  def approve
    @activity = Activity.available_to(current_user).find(params[:id])
    authorize! :approve, @activity
    @activity.update_attributes({ :approved => params[:checked] })
    render :nothing => true
  end

  def use_budget_codings_for_spend
    @activity = Activity.available_to(current_user).find(params[:id])
    authorize! :update, @activity
    @activity.update_attributes({ :use_budget_codings_for_spend => params[:checked] })
    render :nothing => true
  end

  private
  def load_model_help
    @model_help = ModelHelp.find_by_model_name("Activity")
  end
end
