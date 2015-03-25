class ArticlesSweeper < ActionController::Caching::Sweeper
  observe Article

  def after_save(article)
    expire_actions(article)
  end

  def after_destroy(article)
    expire_actions(article)
  end

  private

  def expire_actions(article)
    expire_action(article)
    expire_action(article.prev_article) if article.prev_article
    expire_action(article.next_article) if article.next_article
    expire_action(controller: :articles, action: :index)
    expire_action(controller: :articles, action: :index, format: :atom)
  end
end
