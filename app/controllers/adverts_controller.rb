# == Schema Information
#
# Table name: adverts
#
#  id          :integer          not null, primary key
#  description :text
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

class AdvertsController < ApplicationController
  include Breadcrumbs
  def show
    @advert = Advert.find(params[:id])
    breadcrumbs_create(@advert.category)
    add_breadcrumb @advert, advert_path(@advert)
  end
end
