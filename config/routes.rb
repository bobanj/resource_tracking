ActionController::Routing::Routes.draw do |map|

  map.resources :data_responses,
     :only => [ :show, :create, :edit, :update, :index ],
     :member => {:review => :get, :submit => :put, :start => :get}

  map.data_requests 'data_requests', :controller => 'data_requests', :action => :index #until we flesh out this model

  # routes for CSV uploading for various models
  %w[activities funding_flows projects providers funding_sources model_helps comments other_costs organizations users sub_activities].each do |model|
    map.create_from_file model+"/create_from_file", :controller => model, :action => "create_from_file"
    map.create_from_file_form model+"/create_from_file_form", :controller => model, :action => "create_from_file_form"
  end

  map.dashboard 'dashboard', :controller => 'dashboard'
  map.resources :projects, :member => {:delete => :get}, :collection => {:search => :get}
  map.resources :funding_sources, :member => {:delete => :get}, :collection => {:search => :get}
  map.resources :implementers, :member => {:delete => :get}, :collection => {:search => :get}
  map.resources :activities, :member => {:delete => :get, :approve => :put, :use_budget_codings_for_spend => :put }, :collection => {:search => :get} do |activity|
    map.resources :classifications, :member => { :popup_classification => :get }, :active_scaffold => true
    activity.resource :coding, :controller => :code_assignments, :only => [:show, :update]
    map.resources :sub_activities, :active_scaffold => true
  end

  map.resources :organizations,
      :collection => {:browse => :get},
      :member => {:select => :post}, :active_scaffold => true

  map.popup_other_cost_coding "popup_other_cost_coding", :controller => 'other_costs', :action => 'popup_coding'

  map.resources :indicators, :active_scaffold => true
  map.resources :comments, :active_scaffold => true
  map.resources :field_helps, :active_scaffold => true
  map.resources :model_helps, :active_scaffold => true
  #map.resources :funding_flows, :active_scaffold => true
  map.resources :codes, :active_scaffold => true
  map.resources :other_costs, :active_scaffold => true

  map.resources :users, :active_scaffold => true
  map.resource :user_session

  map.resources :help_requests, :active_scaffold => true

  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

  #reports
  map.resources :reports, :only => [:index, :show]
  map.namespace "admin" do |admin|
    admin.dashboard 'dashboard', :controller => 'dashboard'
    admin.resources :reports, :only => [:index, :show]
  end

  map.static_page ':page',
                  :controller => 'static_page',
                  :action => 'show',
                  :page => Regexp.new(%w[about contact help news].join('|'))

  map.root :controller => 'static_page', :action => 'index' # a replacement for public/index.html
end
