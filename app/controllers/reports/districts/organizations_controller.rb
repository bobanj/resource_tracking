class Reports::Districts::OrganizationsController < Reports::BaseController
  MTEF_CODE_LEVEL = 1 # all level 1 MTEF codes
  before_filter :load_location

  def index
    @organizations     = Reports::OrganizationReport.top_by_spent_and_budget({
                         :per_page => 25, :page => params[:page], :sort => params[:sort],
                         :code_ids => [@location.id], :type => 'district'})
    @spent_pie_values  = Charts::DistrictPies::organizations(@location, "CodingSpendDistrict")
    @budget_pie_values = Charts::DistrictPies::organizations(@location, "CodingBudgetDistrict")
  end

  def show
    @organization      = Organization.find(params[:id])
    @treemap           = params[:chart_type] == "treemap" || params[:chart_type].blank?
    code_type          = get_code_type_and_initialize(params[:code_type])
    activities         = @organization.dr_activities

    if @treemap
      @code_spent_values   = Charts::DistrictTreemaps::treemap(@location, code_type, activities, true)
      @code_budget_values  = Charts::DistrictTreemaps::treemap(@location, code_type, activities, false)
    else
      @code_spent_values  = Charts::DistrictPies::organization_pie(@location, activities, code_type, true)
      @code_budget_values = Charts::DistrictPies::organization_pie(@location, activities, code_type, false)
    end
  end

  private

    def load_location
      @location = Location.find(params[:district_id])
    end
end
