# QuotesController - handles all CRUD operations for quotes
class QuotesController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_quote, only: [:show, :edit, :update, :destroy]
  before_action :require_quote_owner, only: [:edit, :update, :destroy]

  # GET /quotes
  def index
    if admin_user?
      @quotes = Quote.includes(:user, :source, :categories).order(created_at: :desc)
    elsif logged_in?
      @quotes = current_user.quotes.includes(:source, :categories).order(created_at: :desc)
    else
      redirect_to root_path
    end
  end

  # GET /quotes/:id
  def show
    unless @quote.ispublic? || (logged_in? && current_user == @quote.user) || admin_user?
      flash[:alert] = "That quote is private."
      redirect_to root_path
    end
  end

  # GET /quotes/new
  def new
    @quote = Quote.new
    load_sources_and_categories
  end

  # POST /quotes
  def create
    @quote = current_user.quotes.build(quote_params)
    @selected_category_ids = params[:category_ids] || []

    # Manually check category selection BEFORE calling save
    if @selected_category_ids.empty?
      @quote.valid?
      @quote.errors.add(:base, "You must select at least one category.")
      load_sources_and_categories
      render :new, status: :unprocessable_entity
      return
    end

    if @quote.save
      assign_categories
      flash[:notice] = "Quote added successfully!"
      redirect_to @quote
    else
      load_sources_and_categories
      render :new, status: :unprocessable_entity
    end
  end

  # GET /quotes/:id/edit
  def edit
    load_sources_and_categories
  end

  # PATCH /quotes/:id
  def update
    @selected_category_ids = params[:category_ids] || []

    # Manually check category selection BEFORE calling update
    if @selected_category_ids.empty?
      @quote.valid?
      @quote.errors.add(:base, "You must select at least one category.")
      load_sources_and_categories
      render :edit, status: :unprocessable_entity
      return
    end

    if @quote.update(quote_params)
      @quote.quote_categories.destroy_all
      assign_categories
      flash[:notice] = "Quote updated successfully!"
      redirect_to @quote
    else
      load_sources_and_categories
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /quotes/:id
  def destroy
    @quote.destroy
    flash[:notice] = "Quote deleted."
    redirect_to profile_path
  end

  private

  def set_quote
    @quote = Quote.find_by(id: params[:id])
    unless @quote
      flash[:alert] = "Quote not found."
      redirect_to root_path
    end
  end

  def require_quote_owner
    unless current_user == @quote.user || admin_user?
      flash[:alert] = "You do not have permission to modify that quote."
      redirect_to root_path
    end
  end

  def assign_categories
    selected_ids = params[:category_ids] || []
    selected_ids.each do |cat_id|
      category = Category.find_by(id: cat_id)
      @quote.quote_categories.create(category: category) if category
    end
  end

  def load_sources_and_categories
    @sources = Source.order(:fname)
    @categories = Category.order(:catname)
  end

  def quote_params
    params.require(:quote).permit(:qtext, :qyear, :qcom, :ispublic, :source_id)
  end
end
