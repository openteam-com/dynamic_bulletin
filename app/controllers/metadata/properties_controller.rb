class Metadata::PropertiesController < Metadata::ApplicationController
  before_action :find_category
  before_action :find_property, only: [:show, :edit, :update, :destroy]

  def new
    @property = params[:property][:type].constantize.new(property_params)
  end

  def create
    @property = params[:property][:type].constantize.new(property_params)
    @property.category = @category

    @property.save

    respond_with @property, location: -> { metadata_category_path(@property.category) }
  end

  private
  def find_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:title, :max_length)
  end

  def find_category
    @category = Category.find(params[:category_id])
  end
end
