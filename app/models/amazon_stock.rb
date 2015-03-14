class AmazonStock < ActiveRecord::Base
  CONFIG_FILE = File.join(Rails.root, "config/amazon.yml")

  class << self
    def find_by_asin(asin)
      return nil if asin.blank?

      amazon = self.where(asin: asin).first
      if !amazon || amazon.updated_at < 1.week.ago
        amazon ||= self.new(asin: asin)
        amazon.reload!
      end

      amazon
    rescue => ex
      Rails.logger.warn(ex.inspect)
      nil
    end

    def load_config
      return if @_loaded_config

      config = YAML.load_file(CONFIG_FILE)

      ::Amazon::Ecs.options = {
        associate_tag: config["associate_tag"],
        AWS_access_key_id: config["access_key"],
        AWS_secret_key: config["secret_key"]
      }

      @_loaded_config = true
    end
  end

  def reload!
    item = item_lookup(asin)
    self.url = item.get("DetailPageURL")
    url_will_change!

    attribute_reload(item.get_element('ItemAttributes'))
    image_reload(item, 'medium')
    image_reload(item, 'small')

    save!
  end

  private

  def item_lookup(asin)
    self.class.load_config

    ::Amazon::Ecs.item_lookup(
      asin,
      response_group: 'ItemAttributes, Images',
      country: 'jp'
    ).items.first
  end

  def attribute_reload(element)
    self.product_name = element.get("Title").slice(0, 255)
    self.manufacturer = element.get("Manufacturer").slice(0, 255)
    self.media = element.get("Binding").slice(0, 255)
    self.release_date = element.get("PublicationDate").presence || element.get("ReleaseDate") || ""
    authors = element.get_array("Author")
    self.creator = authors.join(", ") if authors.size < 10

  end

  def image_reload(item, size)
    image = item.get_hash("#{size.capitalize}Image")
    return if image.nil? || image["URL"].blank?
    write_attribute("#{size}_image_url", image["URL"])
    write_attribute("#{size}_image_width", image["Width"])
    write_attribute("#{size}_image_height", image["Height"])
  end
end
