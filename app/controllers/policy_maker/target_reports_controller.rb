class PolicyMaker::TargetReportsController < ApplicationController

  def index
    @code_roots                  = Code.for_activities.roots
    @target_amounts              = Code.for_activities.all.map_to_hash{ |b| {b.id => b.target_amount} }
    @actual_budgeted_amounts     = Code.for_activities.all.map_to_hash{ |b| {b.id => b.code_assignments.with_type('CodingBudget').sum(:cached_amount)} }
    @max_targets                 = @target_amounts.values.max.to_i
    @max_actual                  = @actual_budgeted_amounts.values.max.to_i
    @max                         = [@max_targets, @max_actual].max
  end

  def show
    @code = Code.find(params[:id])
    render :layout => "iframe"
  end
end
