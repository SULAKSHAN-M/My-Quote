# ApplicationController - base controller with shared auth helpers
class ApplicationController < ActionController::Base
  # Make helpers available to all views
  helper_method :current_user, :logged_in?, :admin_user?

  private

  # Returns the currently logged-in user based on session[:user_id]
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Returns true if a user is currently logged in
  def logged_in?
    !current_user.nil?
  end

  # Returns true if current user is an admin
  def admin_user?
    logged_in? && current_user.is_admin?
  end

  # Redirect to login if not authenticated
  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access that page."
      redirect_to login_path
    end
  end

  # Redirect to home if not admin
  def require_admin
    unless admin_user?
      flash[:alert] = "You do not have permission to access that page."
      redirect_to root_path
    end
  end

  # Ensure only the owner or admin can access a resource
  def require_owner_or_admin(owner)
    unless current_user == owner || admin_user?
      flash[:alert] = "You do not have permission to perform that action."
      redirect_to root_path
    end
  end
end
