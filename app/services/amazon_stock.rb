class AmazonStock
  attr_reader :image_url, :url, :product_name

  class << self
    def add_content(asin, type)
      body = ""
      return body if asin.blank?

      amazon = new(asin: asin)
      body += %Q|[![Amazon](#{amazon.image_url})](#{amazon.url})| if type[:image]
      body += %Q|[「#{amazon.product_name}」](#{amazon.url})| if type[:title]
      body
    rescue => ex
      Rails.logger.warn(ex.inspect)
      body
    end
  end

  def initialize(asin: "")
    item = item_lookup(asin)
    @url = item.get("DetailPageURL")

    element = item.get_element('ItemAttributes')
    @product_name = element.get("Title").slice(0, 255)

    image = item.get_hash("MediumImage")
    @image_url = image && image["URL"]
  end

  private

  def item_lookup(asin)
    load_config

    ::Amazon::Ecs.item_lookup(
      asin,
      response_group: 'ItemAttributes, Images',
      country: 'jp'
    ).items.first
  end

  def load_config
    ::Amazon::Ecs.options = {
      associate_tag: config["associate_tag"],
      AWS_access_key_id: config["access_key"],
      AWS_secret_key: config["secret_key"]
    }
  end

  def config
    Rails.application.secrets.amazon
  end
end
