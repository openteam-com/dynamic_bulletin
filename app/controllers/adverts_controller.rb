class AdvertsController < ApplicationController
  def index
    @adverts = Advert.all
  end
end
