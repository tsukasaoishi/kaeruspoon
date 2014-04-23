class ArticleContent < ActiveRecord::Base
  validates :body, presence: true
end
