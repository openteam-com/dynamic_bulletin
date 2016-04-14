require 'uri'

class RestAppParser
  attr_reader :url, :data, :token, :date_from, :category_id

  def initialize(params = {})
    @url = Settings['importers.rest_app_url']
    @token = Settings['importers.rest_app_token']
    @date_from = params[:date_from]
    @category_id = params[:category_id]
  end

  def parse!
    request
    store
  end

  private
  def request
    RestClient::Request.execute method: :get, url: url_with_payload do |response, _, __, ___|
      @data = JSON.parse(response)
    end
  end

  def store
    AvitoDatum.create! rest_app_category_id: category_id, data: data['data']
  end

  def url_with_payload
    # 24 - Квартиры
    # 657310 - Томская область
    url + "?login=bvm@ai-factory.com" +
      "&token=#{token}" +
      "&category_id=#{category_id}" +
      "&region_id=657310" +
      "&format=json" +
      "&date1=#{URI.encode(date_from + '+00:00:00')}" +
      "&date2=#{URI.encode(date_from + '+23:59:59')}"
  end
end
