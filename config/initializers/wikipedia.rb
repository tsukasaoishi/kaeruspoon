require 'wikipedia'

Wikipedia.Configure { domain "ja.wikipedia.org" }

module Wikipedia
  class Page
    # PullRequest : https://github.com/kenpratt/wikipedia-client/pull/13
    def redirect?
      content && content.match(/\#REDIRECT\s*\[\[(.*?)\]\]/i)
    end

    def sample_content
      return nil unless sanitized_content
      sanitized_content.chars[0..400].join.gsub(/<[^>]+>/, "").sub(/<.+$/,"") + "..."
    end
  end
end
