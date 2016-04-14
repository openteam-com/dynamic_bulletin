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
    initialize_breadcrumbs
  end

  def initialize_breadcrumbs
    breadcrumbs_create(@advert.category)
    add_breadcrumb @advert.category, category_path(@advert.category)
    add_breadcrumb @advert
  end
end
