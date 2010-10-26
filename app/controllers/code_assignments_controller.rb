class CodeAssignmentsController < ApplicationController
  authorize_resource

  include ActionView::Helpers::NumberHelper # number_to_currency

  def show
    @activity = Activity.available_to(current_user).find(params[:activity_id])
    authorize! :read, @activity

    @coding_type = params[:coding_type] || 'CodingBudget'
    coding_class = @coding_type.constantize

    @codes = coding_class.available_codes(@activity)
    @current_assignments = coding_class.with_activity(@activity).all.map_to_hash{ |b| {b.code_id => b} }

    @coding_error = add_code_assignments_error(coding_class, @activity)

    if params[:tab].present?
      # ajax requests for all tabs except the first one
      render :partial => 'tab', :locals => { :coding_type => @coding_type, :activity => @activity, :codes => @codes, :tab => params[:tab] }, :layout => false
    else
      # show page with first tab loaded
      @model_help = ModelHelp.find_by_model_name 'CodeAssignment'
      render :action => 'show'
    end
  end

  def update
    @activity = Activity.available_to(current_user).find(params[:activity_id])
    authorize! :update, @activity

    coding_class = params[:coding_type].constantize
    if params[:activity].present? && params[:activity][:updates].present?
      coding_class.update_codings(params[:activity][:updates], @activity)
      flash[:notice] = "Activity classification was successfully updated. Please check that you have completed all the other tabs if you have not already done so."
    end

    @coding_error = add_code_assignments_error(coding_class, @activity)
    flash[:error] = @coding_error if @coding_error

    redirect_to activity_coding_path(@activity)
  end

  private
  def add_code_assignments_error(coding_class, activity)
    unless coding_class.classified(activity)
      coding_name = get_coding_name(coding_class)
      coding_type = get_coding_type(coding_class)
      coding_type_amount = activity.send(get_coding_type(coding_class))
      coding_amount = activity.send("#{coding_class}_amount")
      difference = coding_type_amount - coding_amount
      percent_diff = difference/coding_type_amount * 100
      coding_type_amount = number_to_currency(coding_type_amount, :separator => ".", :unit => "", :delimiter => ",")
      coding_amount = number_to_currency(coding_amount, :separator => ".", :unit => "", :delimiter => ",")
      difference = number_to_currency(difference, :separator => ".", :unit => "", :delimiter => ",")
      percent_diff = number_to_currency(percent_diff, :separator => ".", :unit => "", :delimiter => ",")
 
      "We're sorry, when we added up your #{coding_name} classifications, they equaled #{coding_amount} but the #{coding_type} is #{coding_type_amount} (#{coding_type_amount} - #{coding_amount} = #{difference}, which is #{percent_diff}%). The total classified should add up to #{coding_type_amount}."
    end
  end

  def get_coding_name(klass)
    case klass.to_s
    when 'CodingBudget'
      "Budget Coding"
    when 'CodingBudgetDistrict'
      "Budget by District"
    when 'CodingBudgetCostCategorization'
      "Budget by Cost Category"
    when 'CodingSpend'
      "Spend Coding"
    when 'CodingSpendDistrict'
      "Spend by District"
    when 'CodingSpendCostCategorization'
      "Spend by Cost Category"
    end
  end

  def get_coding_type(klass)
    case klass.to_s
    when 'CodingBudget', 'CodingBudgetDistrict', 'CodingBudgetCostCategorization'
      :budget
    when 'CodingSpend', 'CodingSpendDistrict', 'CodingSpendCostCategorization'
      :spend
    end
  end
end
