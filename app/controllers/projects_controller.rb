class ProjectsController < Reporter::BaseController
  inherit_resources
  actions :all, :except => :show
  respond_to :html

  before_filter :load_data_response

  def new
    @project = @data_response.projects.new()
    new!
  end

  # check ownership and redirect to collection path on create instead of show
  def create
    @project = @data_response.projects.new(params[:project])
    create!
  end

  # check ownership and redirect to collection path on update instead of show
  def update
    @project = @data_response.projects.find(params[:id])
    update!
  end

  # check ownership
  def destroy
    @project = @data_response.projects.find(params[:id])
    destroy!
  end

  protected

    def load_data_response
      @data_response = DataResponse.find(params[:response_id])
    end
end
