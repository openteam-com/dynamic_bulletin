class Metadata::PropertiesController < Metadata::ApplicationController
  before_action :find_category
  before_action :find_property, only: [:show, :edit, :update, :destroy]

  def new
    @property = Property.new property_params
  end

  def create
    @property = @category.properties.create property_params

    respond_with @property, location: -> { metadata_category_path(@category) }
  end

  def edit
  end

  def update
    @property.update(property_params)

    respond_with @property, location: -> { metadata_category_path(@category)  }
  end

  def destroy
    @property.destroy

    respond_with @property, location: -> { metadata_category_path(@category)  }
  end

  private
  def find_property
    @property = @category.properties.find(params[:id])
  end

  def property_params
    params.
      require(:property).
      permit(:title, :kind, :show_on_public, :show_as, :necessarily,
             hierarch_list_items_attributes: [:id, :title, :_destroy],
             list_items_attributes: [:id, :title, :_destroy])
  end

  def find_category
    @category = Category.find(params[:category_id])
  end
end
