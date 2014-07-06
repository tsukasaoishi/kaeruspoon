module ReverseMarkdown
  class Cleaner
    def tidy(string)
      clean_tag_borders(remove_leading_newlines(remove_newlines(string)))
    end
  end
end

module ReverseMarkdown
  @cleaner = nil

  module Converters
    class Pre < Base
      def convert(node)
        "```ruby\n" << node.text << "\n```\n"
      end
    end

    register :pre, Pre.new
  end
end
module ReverseMarkdown
  module Converters
    class Br < Base
      def convert(node)
        "\n"
      end
    end

    register :br, Br.new
  end
end

ArticleContent.transaction do
  ArticleContent.all.each do |ac|
    html = TextDecorator.old_replace(ac.body)
    result = ReverseMarkdown.convert(html, github_flavored: true)
    ac.body = result
    ac.save
  end
end
