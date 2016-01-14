class My::AdvertsController < My::ApplicationController
  before_action :find_advert, only: [:show, :edit, :update, :destroy]

  def index
    @adverts = Advert.all
  end

  def new
    @category = Category.find_by_id(params[:category_id])
    if @category
      @advert = @category.adverts.build
    else
      @categories = Category.ordered
    end
  end

  def create
    @advert = Advert.create(advert_params)

    respond_with @advert, location: -> { [:my, @advert] }
  end

  def edit
  end

  def show
  end

  def update
    @advert.update(advert_params)

    respond_with @advert, location: -> { [:my, @advert] }
  end

  def destroy
    @advert.destroy

    respond_with @advert, location: -> { my_adverts_path }
  end

  private
  def advert_params
    params.require(:advert).permit(:description)
  end

  def find_advert
    @advert = Advert.find(params[:id])
  end
end
