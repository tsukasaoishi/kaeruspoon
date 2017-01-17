class RelatedArticle < ApplicationRecord
  belongs_to :article
  belongs_to :related_article, class_name: "Article"
end
