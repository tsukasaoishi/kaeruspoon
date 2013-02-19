require 'spec_helper'

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
      TextDecorator.interpret_notation(text).should eq("<p>aa</p><pre>bb\ncc</pre><p>dd</p>")
    end
  end
end

