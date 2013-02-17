require 'spec_helper'

describe Article do
  describe "content" do
    it "create new content when to create new article" do
      test_body = "test body"
      a = Article.new(:title => "test", :body => test_body)
      a.save
      a.content.should be_kind_of ArticleContent
      a.content.body.should equal test_body
    end

    it "update content.body when to set article.body" do
      a = Article.create(:title => "test")
      test_body = "test update body"
      a.body = test_body
      a.save
      a.content.body.should equal test_body
    end
  end
end
