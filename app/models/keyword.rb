class Keyword < ActiveRecord::Base
  has_many :article_keywords, dependent: :destroy
  has_many :articles, through: :article_keywords

  after_save :tree_add

  validates :name, uniqueness: true

  class << self
    def convert(text)
      tree.filter_html(text)
    end

    def search(text)
      tree.search(text).uniq
    end

    def tree
      @tree ||= init_tree
    end

    def clear!
      @tree = nil
    end

    private

    def init_tree
      ret = WordScoop.new(self.pluck("name"))
      ret.link_url = %Q|<a href="/keywords/%s/">%s</a>|
      ret
    end
  end

  private

  def tree_add
    self.class.tree.add(self.name)
  end
end
