require 'redcarpet/compat'

class TextDecorator
  OPTIONS = %i(
    autolink no_intra_emphasis fenced_code_blocks disable_indented_code_blocks
    strikethrough tables lax_spacing space_after_headers superscript underline
    highlight quote footnotes hard_wrap
  )

  class << self
    def replace(text)
      html = Keyword.convert(Markdown.new(text, *OPTIONS).to_html)
      syntax_highlighter(html).html_safe
    end

    def syntax_highlighter(html)
      doc = Nokogiri::HTML(html)
      doc.search("pre").each do |pre|
        pre.replace(Pygments.highlight(
          pre.text.rstrip,
          lexer: pre.children.attribute("class").value
        ))
      end
      doc.to_s
    end
  end
end
