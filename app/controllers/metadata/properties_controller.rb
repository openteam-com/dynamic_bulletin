class Metadata::PropertiesController < Metadata::ApplicationController
  before_action :find_property, only: [:show, :edit, :update, :destroy]

  def create
    category = Category.find(property_params[:category_id])
    @property = category.properties.create(property_params)

    respond_with @property, location: -> { metadata_category_path(@property.category) }
  end

  def get_fields_for_subproperties
    render partial: params[:property_name].underscore and return if request.xhr?
  end

  private
  def find_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:name, :category_id)
  end
end
