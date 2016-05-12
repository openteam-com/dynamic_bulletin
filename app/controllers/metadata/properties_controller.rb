class Metadata::PropertiesController < Metadata::ApplicationController
  before_action :find_category
  before_action :find_property, only: [:edit, :update, :destroy]
  before_action :find_category_property, only: [:edit, :update, :destroy]

  def new
    @property = Property.new property_params
    @category_property = CategoryProperty.new
    @collection_for_filter = determinate_collection_for_filter
  end

  def determinate_collection_for_filter
    case @property.kind.to_s
    when "string"
      []
    when "limited_list"
      [:select, :range, :multiselect, :radio_buttons, :boolean, :range_buttons, :range_select]
    when "unlimited_list"
      [:select, :range, :multiselect, :radio_buttons, :boolean, :range_buttons, :range_select]
    when "hierarch_limited_list"
      [:boolean]
    when "integer"
      [:check_boxes, :range, :range_buttons, :range_select]
    when "float"
      [:check_boxes, :range, :range_buttons, :range_select]
    when "boolean"
      [:boolean]
    end
  end


  def create
    @property = Property.create property_params

    respond_with @property,
      location: -> { new_metadata_category_property_category_property_path(@category, @property, :params => category_property_params) }
  end

  def edit
    @collection_for_filter = determinate_collection_for_filter
  end

  def update
    @property.update(property_params)

    respond_with @property,
      location: -> { edit_metadata_category_property_category_property_path(@category, @property, @category_property, :params => category_property_params) }
  end

  def destroy
    @category_property.destroy

    respond_with @property, location: -> { metadata_category_path(@category)  }
  end

  private
  def find_property
    @property = @category.properties.find(params[:id])
  end

  def property_params
    params.
      require(:property).
      permit(:title, :kind, :category_id, :show_on_filter_as,
             hierarch_list_items_attributes: [:id, :title, :_destroy],
             list_items_attributes: [:id, :title, :_destroy])
  end

  def category_property_params
    params.
      require(:property).require(:category_property).
      permit(:show_on_public, :show_as, :necessarily, :category_id)
  end

  def find_category
    @category = Category.find(params[:category_id])
  end

  def find_category_property
    @category_property = CategoryProperty.where(:category_id => @category, :property_id => @property).first
  end
end
