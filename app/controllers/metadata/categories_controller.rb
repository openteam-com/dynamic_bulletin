class Metadata::CategoriesController < Metadata::ApplicationController
  before_action :find_category, only: [:show, :edit, :destroy]

  def index
    @categories = Category.roots.ordered
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render partial: 'children', locals: { category: @category.parent } and return if request.xhr?
      redirect_to metadata_category_path(@category)
    else
      render :new and return
    end
  end

  def edit
  end

  def show
  end

  def update
    if @category.update(category_params)
      render partial: 'children', locals: { category: @category.parent } and return if request.xhr?
      redirect_to metadata_category_path(@category)
    else
      render :edit and return
    end
  end

  def add_existed
    @category = Category.find(params[:category_id])
    @categories = Category.roots.ordered
  end

  def remove_link
    Category.find(params[:category_id]).update_column(:connect_with_id,  nil)
    render partial: 'children', locals: { category: Category.find(params[:parent_id]) } and return
  end

  def destroy
    if @category.parent
      @parent = @category.parent
      @category.destroy
      render partial: 'children', locals: { category: @parent } and return if request.xhr?
    else
      @category.destroy
      redirect_to metadata_categories_path
    end
  end

  def update_category_property_position
    CategoryProperty.find(params[:id]).update_attribute(:row_order_position, params[:row_order])
    render nothing: true and return
  end

  private
  def category_params
    params.require(:category).permit(:title, :parent_id, property_ids: [], link_ids: [])
  end

  def find_category
    @category = Category.find(params[:id])
  end
end
