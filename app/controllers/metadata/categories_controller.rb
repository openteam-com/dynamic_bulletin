class Metadata::CategoriesController < Metadata::ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.ordered
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(category_params)

    respond_with @category, location: -> { metadata_category_path(@category) }
  end

  def edit
  end

  def show
    @property = Property.new
  end

  def update
    @category.update(category_params)

    respond_with @category, location: -> { metadata_category_path(@category)  }
  end

  def destroy
    @category.destroy

    respond_with @category, location: -> { metadata_categories_path }
  end

  private
  def category_params
    params.require(:category).permit(:title)
  end

  def find_category
    @category = Category.find(params[:id])
  end
end
