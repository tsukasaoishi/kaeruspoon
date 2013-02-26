class TextDecorator
  #
  # build <pre> tag
  #
  class PreBuffer < Array
    REGEXP_PRE_BEGIN = /^>\|\|$/
    REGEXP_PRE_END = /^\|\|<$/

    def begin?(str)
      @on = (str =~ REGEXP_PRE_BEGIN)
    end

    def finish?(str)
      str =~ REGEXP_PRE_END
    end

    def on?
      !!@on
    end

    def flash
      return "" if empty?

      CodeRay.scan(join("\n"), :ruby).div
    ensure
      @on = false
      clear
    end
  end
end