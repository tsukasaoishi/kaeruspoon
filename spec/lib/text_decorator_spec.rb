require 'spec_helper'

include ActionView::Helpers::UrlHelper

describe TextDecorator do
  describe ".interpret_notation" do
    it "regard CR/LF as <br /> tag" do
      text = "aa\nbb\rcc\r\ndd"
      TextDecorator.interpret_notation(text).should match(%r!aa<br />bb<br />cc<br />dd!) 
    end

    it "regard over double CR/LF as <p> tag block" do
      text = "aa\r\rbb\n\ncc\r\n\r\ndd"
      TextDecorator.interpret_notation(text).should eq("<p>aa</p><p>bb</p><p>cc</p><p>dd</p>")
    end

    it "refard from '>||' to '||<' as <pre> tag block" do
      text = "aa\n>||\nbb\ncc\n||<\ndd"
      TextDecorator.interpret_notation(text).should match(%r!<p>aa</p>.+<pre>bb\ncc</pre>.+<p>dd</p>!m)
    end

    it "regard [url:title=xxx] or [url] as a tag" do
      url_aaa = "http://aaa.com"
      url_bbb = "http://bbb.com"
      url_ccc = "https://ccc.com"
      link_aaa = link_to("aaa", url_aaa, :target => "_blank")
      link_bbb = link_to(link_bbb, url_bbb, :target => "_blank")
      link_ccc = link_to(link_ccc, url_ccc, :target => "_blank")

      text = "[#{url_aaa}:title=aaa][#{url_bbb}][#{url_ccc}]"
      TextDecorator.interpret_notation(text).should eq(
        "<p>" + link_aaa + link_bbb + link_ccc + "</p>"
      )
    end

    it "regard [a:xxx] as a link to article" do
      title = "test title"
      article = mock_model(Article, :title => title, :id => 1)
      Article.should_receive(:find_by_id).with(1).and_return(article)
      text = "[a:1]"
      TextDecorator.interpret_notation(text).should eq(
        "<p>" + link_to(article.title, "/articles/1") + "</p>"
      )
    end
  end
end

