class Articles::ArchiveController < ApplicationController
  caches_action :index, expires_in: 1.minute

  def index
    @calendar = Article.archive_articles
    @title = I18n.t(:archive_articles)
    @sub_title = @title
  end
end
