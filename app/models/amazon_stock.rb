class AmazonStock < ActiveRecord::Base
  CONFIG_FILE = File.join(Rails.root, "config/amazon.yml")

  class << self
    def find_by_asin(asin)
      return nil if asin.blank?

      amazon = self.where(asin: asin).first
      if !amazon || amazon.updated_at < 1.week.ago
        amazon ||= self.new(asin: asin)

        item = item_lookup(asin).items.first
        element = item.get_element('ItemAttributes')

        amazon.url = item.get("DetailPageURL")
        medium_image = item.get_hash("MediumImage")
        small_image = item.get_hash("SmallImage")

        if medium_image && medium_image["URL"].present?
          amazon.medium_image_url = medium_image["URL"]
          amazon.medium_image_width = medium_image["Width"]
          amazon.medium_image_height = medium_image["Height"]
        end

        if small_image && small_image["URL"].present?
          amazon.small_image_url = small_image["URL"]
          amazon.small_image_width = small_image["Width"]
          amazon.small_image_height = small_image["Height"]
        end

        amazon.product_name = element.get("Title")
        amazon.creator = element.get_array("Author").join(", ")
        amazon.manufacturer = element.get("Manufacturer")
        amazon.media = element.get("Binding")
        amazon.release_date = element.get("PublicationDate").presence || element.get("ReleaseDate")
        
        amazon.updated_at = Time.now
        amazon.save!
      end

      amazon
    rescue Exception
      nil
    end

    private

    def item_lookup(asin)
      load_config unless @_loaded_config

      ::Amazon::Ecs.item_lookup(
        asin,
        response_group: 'ItemAttributes, Images',
        country: 'jp'
      )
    end

    def load_config
      config = YAML.load_file(CONFIG_FILE)

      ::Amazon::Ecs.options = {
        associate_tag: config["associate_tag"],
        AWS_access_key_id: config["access_key"],
        AWS_secret_key: config["secret_key"]
      }

      @_loaded_config = true
    end
  end
end
