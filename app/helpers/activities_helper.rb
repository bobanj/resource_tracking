module ActivitiesHelper
  def label_string model_class, column
    if model_class == Activity
      ActivitiesController.label_for column
    elsif model_class == OtherCost
      OtherCostsController.label_for column
    end
  end
  def options_for_association_conditions(association)
      logger.debug("in 1")
    if params[:controller] == "activities" #this might intro a bug
      #right now for some reason projects is trying to pick up the
      #options for the association for activities
      logger.debug("in 2")
      if association.name == :provider
          ids = Set.new
          Project.available_to(current_user).all.each do |p|
            ids.merge p.providers
          end
          ["id in (?)", ids]
      elsif association.name == :projects
          ids = Set.new
          Project.available_to(current_user).all.each do |p|
            ids.merge [p.id]
          end
          ["id in (?)", ids]
      elsif association.name == :locations
          unless @record.projects.empty?
            ids=Set.new
            @record.projects.each do |p| #in future this should scope right with default
              ids.merge p.location_ids
            end
            ["id in (?)", ids]
          else
            ids=Set.new
            Project.available_to(current_user).all.each do |p| #in future this should scope right with default
              ids.merge p.location_ids
            end
            ["id in (?)", ids]
          end
      else
        super
      end
    end
  end
end
