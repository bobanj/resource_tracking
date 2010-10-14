# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Sortable table
  include SortableTable::App::Helpers::ApplicationHelper

  # Usage: simply invoke title() at the top of each view
  # E.g.
  # - title "Home"
  def title(page_title)
    content_for(:title) { page_title }
  end

  # GR: I'd like to move this to its respective controller helper
  # - but it seems the AS plugin code has been modified to use this method?
  #
  # Converts a (string) number to a percentage, preserving the decimals (if they exist)
  #  99 => 99
  #  50.1 => 50.1
  def number_to_percentage(n)
    n = n.to_f
    return "" if n <= 0.0
    sprintf("%2.f", n)
  end

  # TODO: remove this
  def user_dashboard_path current_user
    if current_user
      if current_user.role? :admin
        admin_dashboard_path
      elsif current_user.role? :reporter
        dashboard_path
      elsif current_user.role? :activity_manager
        dashboard_path
      end
    end
  end

  def active_tab?(tab_name)
    case tab_name
    when 'my_data':
      controller.controller_name != 'dashboard' && controller.controller_name != 'reports' && (controller.controller_name != 'static_pages' && params[:page] != 'help') && controller.controller_name != 'users'
    when 'reports':
      controller.controller_name == 'reports'
    when 'help':
      controller.controller_name == 'static_page' && params[:page] == 'help'
    when 'my_profile':
      controller.controller_name == 'users' && controller.action_name == 'edit'
    end

  end
end
