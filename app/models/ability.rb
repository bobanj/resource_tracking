class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(:roles => []) #guest
    if user.role? :admin
      can :manage, :all
    elsif user.role?(:activity_manager)
      can :manage, Activity
      can :approve, Activity
      #can :approve, Activity do |activity|
        #activity.try(:organization) == user.organization
      #end
      can :manage, [Project, FundingFlow, Organization, Activity, OtherCost, Comment, CodeAssignment]
      can :create, Organization
      can :update, User, :id => user.id
      can :read, Code
      can :read, ModelHelp
      can :read, FieldHelp
      can :create, HelpRequest
    elsif user.role?(:reporter)
      can :manage, [Project, FundingFlow, Organization, Activity, OtherCost, Comment, CodeAssignment]
      # :manage seems to let all non-RESTful actions thru, so explicity remove this perm for reporters
      cannot :approve, Activity
      can :create, Organization
      can :update, User, :id => user.id
      can :read, Code
      can :read, ModelHelp
      can :read, FieldHelp
      can :create, HelpRequest
      can :read, :users_in_my_organization
    else #guest user
      can :create, HelpRequest
    end
  end
end
