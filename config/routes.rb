ActionController::Routing::Routes.draw do |map|

  map.resources :data_responses, :member => {:review => :get, :submit => :put, :start => :get}

  map.data_requests 'data_requests', :controller => 'data_requests', :action => :index #until we flesh out this model

  # routes for CSV uploading for various models
  %w[activities funding_flows projects providers funding_sources model_helps comments other_costs organizations users sub_activities].each do |model|
    map.create_from_file model+"/create_from_file", :controller => model, :action => "create_from_file"
    map.create_from_file_form model+"/create_from_file_form", :controller => model, :action => "create_from_file_form"
  end

  map.funding_sources_data_entry "funding_sources",
    :controller => 'funding_sources', :action => 'index'

  map.providers_data_entry "providers",
    :controller => 'providers', :action => 'index'

  map.resources :projects,
    :collection => {:browse => :get},
    :member => {:select => :post}, :active_scaffold => true

  map.resources :organizations,
      :collection => {:browse => :get},
      :member => {:select => :post}, :active_scaffold => true


  map.resources :activities,
                :member => { :approve => :put, :use_budget_codings_for_spend => :put },
                :active_scaffold => true          do |activity|

    map.resources :classifications, :member => { :popup_classification => :get }, :active_scaffold => true
    activity.resource :coding, :controller => :code_assignments, :only => [:show, :update]
    map.resources :sub_activities, :active_scaffold => true
  end

  map.popup_other_cost_coding "popup_other_cost_coding", :controller => 'other_costs', :action => 'popup_coding'

  map.resources :comments, :active_scaffold => true
  map.resources :field_helps, :active_scaffold => true
  map.resources :model_helps, :active_scaffold => true
  map.resources :funding_flows, :active_scaffold => true
  map.resources :codes, :active_scaffold => true
  map.resources :other_costs, :active_scaffold => true

  map.resources :users, :active_scaffold => true
  map.resource :user_session

  map.resources :help_requests, :active_scaffold => true

  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

  map.reporter_dashboard "reporter_dashboard", :controller => 'static_page', :action => "reporter_dashboard"

  #reports
  map.activities_by_district 'activities_by_district', :controller => 'reports', :action => 'activities_by_district'
  map.activities_by_district_sub_activities 'activities_by_district_sub_activities', :controller => 'reports', :action => 'activities_by_district_sub_activities'
  map.activities_by_budget_coding 'activities_by_budget_coding', :controller => 'reports', :action => 'activities_by_budget_coding'
  map.activities_by_budget_cost_cat 'activities_by_budget_cost_cat', :controller => 'reports', :action => 'activities_by_budget_cost_cat'
  map.activities_by_expenditure_coding 'activities_by_expenditure_coding', :controller => 'reports', :action => 'activities_by_expenditure_coding'
  map.activities_by_expenditure_cost_cat 'activities_by_expenditure_cost_cat', :controller => 'reports', :action => 'activities_by_expenditure_cost_cat'
  map.activity_report 'activity_report', :controller => 'reports', :action => 'activity_report'
  map.activities_by_district_new 'activities_by_district_new', :controller => 'reports', :action => 'activities_by_district_new'
  map.activities_by_budget_coding_new 'activities_by_budget_coding_new', :controller => 'reports', :action => 'activities_by_budget_coding_new'
  map.activities_by_district_row_report 'activities_by_district_row_report', :controller => 'reports', :action => 'activities_by_district_row_report'
  map.activities_by_budget_stratprog 'activities_by_budget_stratprog', :controller => 'reports', :action => 'activities_by_budget_stratprog'
  map.users_by_organization 'users_by_organization', :controller => 'reports', :action => 'users_by_organization'
  map.users_in_my_organization 'users_in_my_organization', :controller => 'reports', :action => 'users_in_my_organization'

  # these routes make the pages accessible without security checks
  #TODO - this doesnt belong here. Must be moved to the controller - GR
  %w[about news contact submit].each do |p|
    map.send(p.to_sym, p, :controller => 'static_page', :action => p)
  end

  map.static_page ':page',
                  :controller => 'static_page',
                  :action => 'show',
                  :page => Regexp.new(%w[about contact admin_dashboard about news submit user_guide reports].join('|'))

  map.root :controller => 'static_page', :action => 'index' # a replacement for public/index.html

  map.namespace :admin do |admin|
    admin.resources :data_responses
  end

end
