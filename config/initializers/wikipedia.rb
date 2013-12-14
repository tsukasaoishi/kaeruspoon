require 'wikipedia'

Wikipedia.Configure { domain "ja.wikipedia.org" }

# PullRequest : https://github.com/kenpratt/wikipedia-client/pull/13
module Wikipedia
  class Page
    def redirect?
      content && content.match(/\#REDIRECT\s*\[\[(.*?)\]\]/i)
    end
  end
end
