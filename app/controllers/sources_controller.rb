# SourcesController - manages philosophical sources (philosophers/authors)
class SourcesController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: [:destroy]
  before_action :set_source, only: [:show, :edit, :update, :destroy]

  # GET /sources
  def index
    @sources = Source.order(:fname)
  end

  # GET /sources/:id
  def show
    # Show quotes attributed to this source (only public, unless logged in as owner or admin)
    @quotes = if admin_user?
      @source.quotes.includes(:user, :categories)
    elsif logged_in?
      @source.quotes.where("ispublic = ? OR user_id = ?", true, current_user.id).includes(:user, :categories)
    else
      @source.quotes.public_quotes.includes(:user, :categories)
    end
  end

  # GET /sources/new
  def new
    @source = Source.new
  end

  # POST /sources
  def create
    @source = Source.new(source_params)
    if @source.save
      flash[:notice] = "Source '#{@source.full_name}' added successfully."
      redirect_to @source
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /sources/:id/edit
  def edit; end

  # PATCH /sources/:id
  def update
    if @source.update(source_params)
      flash[:notice] = "Source updated."
      redirect_to @source
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sources/:id (admin only)
  def destroy
    @source.destroy
    flash[:notice] = "Source deleted."
    redirect_to sources_path
  end

  private

  def set_source
    @source = Source.find(params[:id])
  end

  def source_params
    params.require(:source).permit(:fname, :lname, :byear, :dyear, :bio)
  end
end
