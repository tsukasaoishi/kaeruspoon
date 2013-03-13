class TextDecorator
  #
  # build <pre> tag
  #
  class PreBuffer < Array
    REGEXP_PRE_BEGIN = /^>\|(.*)\|$/
    REGEXP_PRE_END = /^\|\|<$/

    def begin?(str)
      @on = (str =~ REGEXP_PRE_BEGIN).tap do
        @lang = $1.presence
      end
    end

    def finish?(str)
      str =~ REGEXP_PRE_END
    end

    def on?
      !!@on
    end

    def flash
      return "" if empty?

      lang = @lang
      @lang = nil
      CodeRay.scan(join("\n"), lang || :ruby).div
    ensure
      @on = false
      clear
    end
  end
end
