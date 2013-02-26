require 'spec_helper'

include ActionView::Helpers::UrlHelper
include ActionView::Helpers::AssetTagHelper

describe TextDecorator do
  describe ".replace" do
    it "regard CR/LF as <br /> tag" do
      text = "aa\nbb\rcc\r\ndd"
      TextDecorator.replace(text).should match(%r!aa<br />bb<br />cc<br />dd!) 
    end

    it "regard over double CR/LF as <p> tag block" do
      text = "aa\r\rbb\n\ncc\r\n\r\ndd"
      TextDecorator.replace(text).should eq("<p>aa</p><p>bb</p><p>cc</p><p>dd</p>")
    end

    it "refard from '>||' to '||<' as <pre> tag block" do
      text = "aa\n>||\nbb\ncc\n||<\ndd"
      TextDecorator.replace(text).should match(%r!<p>aa</p>.+<pre>bb\ncc</pre>.+<p>dd</p>!m)
    end

    it "regard [url:title=xxx] or [url] as a tag" do
      url_aaa = "http://aaa.com"
      url_bbb = "http://bbb.com"
      url_ccc = "https://ccc.com"
      link_aaa = link_to("aaa", url_aaa, :target => "_blank")
      link_bbb = link_to(link_bbb, url_bbb, :target => "_blank")
      link_ccc = link_to(link_ccc, url_ccc, :target => "_blank")

      text = "[#{url_aaa}:title=aaa][#{url_bbb}][#{url_ccc}]"
      TextDecorator.replace(text).should eq(
        "<p>" + link_aaa + link_bbb + link_ccc + "</p>"
      )
    end

    it "regard [a or d:yyyymmdd] as as a link to date article" do
      title = "test title"
      date = Time.local(2013,1,1)
      text1 = "[a:#{date.strftime("%Y%m%d")}]"
      text2 = "[d:#{date.strftime("%Y%m%d")}]"
      target = link_to(
        date.strftime("%Y年%m月%d日の日記"),
        "/articles/date/#{date.strftime("%Y/%m/%d")}"
      )

      TextDecorator.replace(text1).should match(target)
      TextDecorator.replace(text2).should match(target)
    end

    it "regard [a:xxx] as a link to article" do
      title = "test title"
      article = mock_model(Article, :title => title, :id => 1)
      Article.should_receive(:find_by_id).with(1).and_return(article)
      text = "[a:1]"
      TextDecorator.replace(text).should match(
        link_to(article.title, "/articles/1")
      )
    end

    it "warning display if [a:xxx] is not found article" do
      text = "[a:1]"
      TextDecorator.replace(text).should match(
        %r!<strong style=.+?>\[NotFound:a:1\]</strong>!
      )
    end

    it "regard [text] as a scan tag which has accent class" do
      text = "[aaaaa]"
      TextDecorator.replace(text).should match(%r!<span(.*?)>aaaaa</span>!)
    end

    it "regard [[text] as [text" do
      text = "[[aaa]"
      TextDecorator.replace(text).should match(/\[aaa/)
    end

    it "regard [p:xxx] as a link to image" do
      photo = mock_model(Photo, :id => 1)
      image = double(Paperclip::Attachment)
      large_image_url = "large_image_url"
      original_image_url = "original_image_url"

      Photo.should_receive(:find_by_id).with(1).and_return(photo)
      photo.should_receive(:image).any_number_of_times.and_return(image)
      image.should_receive(:url).with(:large).any_number_of_times.and_return(large_image_url)
      image.should_receive(:url).with(:original).any_number_of_times.and_return(original_image_url)

      text = "[p:1]"
      TextDecorator.replace(text).should match(
        link_to(image_tag(photo.image.url(:large)), photo.image.url(:original), :target => "_blank", :class => "article_image")
      )
    end

    it "warning display if [p:xxx] is not found photo" do
      text = "[p:1]"
      TextDecorator.replace(text).should match(
        %r!<strong style=.+?>\[NotFound:p:1\]</strong>!
      )
    end
  end
end

