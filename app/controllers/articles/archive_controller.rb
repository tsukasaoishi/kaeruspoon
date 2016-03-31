class Articles::ArchiveController < ApplicationController
  caches_action :index, expires_in: 1.month

  def index
    @calendar = Article.archive_articles
    @title = I18n.t(:archive_articles)
  end
end
