class Metadata::CategoriesController < Metadata::ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]

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

      render :show and return
    else
      render :new and return
    end

    #respond_with @category, location: -> { [:metadata, @category.parent.present? ? @category.parent : @category]}
  end

  def edit
  end

  def show
  end

  def update
    @category.update(category_params)

    respond_with @category, location: -> { metadata_category_path(@category)  }
  end

  def destroy
    @category.destroy

    respond_with @category, location: -> { metadata_categories_path }
  end

  def update_property_position
    if request.xhr?
      Property.find(params[:id]).update_attribute :row_order_position, params[:row_order]

      render nothing: true and return
    end
  end

  private
  def category_params
    params.require(:category).permit(:title, :parent_id)
  end

  def find_category
    @category = Category.find(params[:id])
  end
end
