require 'redcarpet/compat'

class TextDecorator
  OPTIONS = %i(
    autolink no_intra_emphasis fenced_code_blocks disable_indented_code_blocks
    strikethrough tables lax_spacing space_after_headers superscript underline
    highlight quote footnotes hard_wrap
  )

  class << self
    def replace(text)
      return text if text.blank?
      html = Keyword.convert(Markdown.new(text, *OPTIONS).to_html)
      syntax_highlighter(html).html_safe
    end

    def replace_without_tags(text)
      return text if text.blank?
      replace(text).gsub(/<.+?>|\r\n|\r|\n/, "").strip
    end

    def syntax_highlighter(html)
      doc = Nokogiri::HTML.fragment(html.encode("UTF-8"))
      doc.search("pre").each do |pre|
        klass = pre.children.attribute("class")
        pre.replace(Pygments.highlight(
          pre.text.rstrip,
          lexer: klass ? klass.value : "text"
        ))
      end
      doc.to_s
    end
  end
end
