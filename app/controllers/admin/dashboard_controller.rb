# Admin::DashboardController - admin landing page
class Admin::DashboardController < ApplicationController
  before_action :require_login
  before_action :require_admin

  # GET /admin
  def index
    @users = User.where(is_admin: false).order(:lname, :fname)
    @total_users = User.count
    @total_quotes = Quote.count
    @total_sources = Source.count
    @total_categories = Category.count
  end
end
