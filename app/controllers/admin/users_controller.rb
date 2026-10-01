# Admin::UsersController - admin management of user accounts
class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /admin/users
  def index
    @users = User.order(:lname, :fname)
  end

  # GET /admin/users/:id
  def show
    @quotes = @user.quotes.includes(:source, :categories).order(created_at: :desc)
  end

  # GET /admin/users/:id/edit
  def edit; end

  # PATCH /admin/users/:id
  def update
    if @user == current_user
      flash[:alert] = "You cannot modify your own admin account from here."
      redirect_to admin_users_path and return
    end
    if @user.update(admin_user_params)
      flash[:notice] = "User '#{@user.full_name}' updated successfully."
      redirect_to admin_users_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/users/:id
  def destroy
    if @user == current_user
      flash[:alert] = "You cannot delete your own account from here."
      redirect_to admin_users_path and return
    end
    @user.destroy
    flash[:notice] = "User account deleted."
    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def admin_user_params
    params.require(:user).permit(:status, :is_admin)
  end
end
