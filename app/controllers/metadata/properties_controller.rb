class Metadata::PropertiesController < Metadata::ApplicationController
  before_action :find_category
  before_action :initialize_property, only: [:new, :create]
  before_action :find_property, only: [:show, :edit, :update, :destroy]

  def new
  end

  def create
    @property.save

    respond_with @property, location: -> { metadata_category_path(@property.category) }
  end

  def edit
  end

  def update
    @property.update(property_params)

    respond_with @property, location: -> { metadata_category_path(@category)  }
  end

  private
  def find_property
    @property = @category.properties.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:title, :kind, :max_length, list_items_attributes: [:title])
  end

  def find_category
    @category = Category.find(params[:category_id])
  end

  def initialize_property
    @property = @category.properties.new(property_params)
  end
end
