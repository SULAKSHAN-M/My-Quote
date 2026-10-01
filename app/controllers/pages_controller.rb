# PagesController - handles public-facing pages (home, search)
class PagesController < ApplicationController
  # GET /  (homepage)
  def home
    # Display the 10 most recently added public quotes, ordered by date descending
    @recent_quotes = Quote.recent_public.limit(10).includes(:user, :source, :categories)
    @categories = Category.order(:catname)
  end

  # GET /search
  def search
    @categories = Category.order(:catname)
    @selected_category = Category.find_by(id: params[:category_id])

    if @selected_category
      # Return public quotes in the selected category
      @quotes = if logged_in?
        @selected_category.quotes
          .where("ispublic = ? OR user_id = ?", true, current_user.id)
          .includes(:user, :source, :categories)
          .order(created_at: :desc)
      else
        @selected_category.quotes.public_quotes.includes(:user, :source, :categories).order(created_at: :desc)
      end
    else
      @quotes = []
    end
  end
end
