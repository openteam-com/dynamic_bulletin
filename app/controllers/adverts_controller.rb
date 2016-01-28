# == Schema Information
#
# Table name: adverts
#
#  id          :integer          not null, primary key
#  description :text
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AdvertsController < ApplicationController
  def index
    @adverts = Advert.all
  end
end
