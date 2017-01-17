class ArticleContent < ApplicationRecord
  validates :body, presence: true
end
