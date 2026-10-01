# CategoriesController - manages philosophical categories
class CategoriesController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: [:destroy]
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.order(:catname)
  end

  # GET /categories/:id
  def show
    # Public search result page - show public quotes in this category
    @quotes = if admin_user?
      @category.quotes.includes(:user, :source)
    elsif logged_in?
      @category.quotes.where("ispublic = ? OR user_id = ?", true, current_user.id).includes(:user, :source)
    else
      @category.quotes.public_quotes.includes(:user, :source)
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category '#{@category.catname}' added."
      redirect_to categories_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /categories/:id/edit
  def edit; end

  # PATCH /categories/:id
  def update
    if @category.update(category_params)
      flash[:notice] = "Category updated."
      redirect_to categories_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /categories/:id (admin only)
  def destroy
    @category.destroy
    flash[:notice] = "Category deleted."
    redirect_to categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:catname)
  end
end
