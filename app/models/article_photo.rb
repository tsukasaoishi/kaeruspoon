class ArticlePhoto < ActiveRecord::Base
  belongs_to :article
  belongs_to :photo
end
