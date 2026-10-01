# UsersController - handles user registration and profile management
class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update, :edit_password, :update_password]

  # GET /signup
  def new
    @user = User.new
  end

  # POST /signup
  def create
    @user = User.new(user_signup_params)
    @user.status = "Active"
    @user.is_admin = false

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Account created! Welcome to MyQuote, #{@user.fname}!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /profile
  def show
    @user = current_user
    @quotes = @user.quotes.includes(:source, :categories).order(created_at: :desc)
  end

  # GET /profile/edit
  def edit
    @user = current_user
  end

  # PATCH /profile
  def update
    @user = current_user
    if @user.update(user_update_params)
      flash[:notice] = "Your profile has been updated."
      redirect_to profile_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /profile/password
  def edit_password
    @user = current_user
  end

  # PATCH /profile/password
  def update_password
    @user = current_user
    # Verify current password before allowing change
    if @user.authenticate(params[:current_password])
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        flash[:notice] = "Password updated successfully."
        redirect_to profile_path
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit_password, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Current password is incorrect."
      render :edit_password, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for signup (includes password fields)
  def user_signup_params
    params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation)
  end

  # Strong parameters for profile update (excludes password)
  def user_update_params
    params.require(:user).permit(:fname, :lname, :email)
  end
end
