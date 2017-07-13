class Articles::ArchiveController < ApplicationController
  def index
    @calendar = Article.archive_articles
    @title = I18n.t(:archive_articles)
    @sub_title = @title
  end
end
