class UserSession < Authlogic::Session::Base

  # Authlogic
  find_by_login_method :find_by_username_or_email # in User model
end
