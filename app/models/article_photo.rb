class ArticlePhoto < ApplicationRecord
  belongs_to :article
  belongs_to :photo
end
