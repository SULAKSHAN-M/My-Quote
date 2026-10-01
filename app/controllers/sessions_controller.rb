# SessionsController - handles user authentication (login/logout)
class SessionsController < ApplicationController
  # GET /login
  def new
    # Redirect already-logged-in users away from login page
    redirect_to root_path if logged_in?
  end

  # POST /login
  def create
    # Find user by downcased email
    user = User.find_by(email: params[:email].downcase.strip)

    if user && user.authenticate(params[:password])
      # Check account status - Suspended/Banned users cannot log in
      if user.active?
        session[:user_id] = user.id
        flash[:notice] = "Welcome back, #{user.fname}!"
        redirect_to root_path
      else
        flash.now[:alert] = "Your account has been #{user.status.downcase}. Please contact an administrator."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /logout
  def destroy
    session.delete(:user_id)
    @current_user = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end
end
