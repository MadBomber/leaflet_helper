# string_template.rb
# this class resulted in pull_requests to the easy_template gem
# Merci to Jeremy Lecerf @redpist for the regex

module LeafletHelper
  class StringTemplate
    def initialize(a_string)
      @text = a_string
    end

    def use(variables)
      @text.gsub(/(\\\{)|((?<!\\)(?:\\\\)*#{variables.map{|v|"\\{#{Regexp.escape(v[0])}\\}"}.join('|')})/i){|s| s[0] == '\\' ? s[1] : variables.fetch(s[1..-2], ( s[1..-2].respond_to?(:to_sym) ? variables.fetch(s[1..-2].to_sym, nil) : nil))}
    end
    alias :<< :use

    def to_s
      @text
    end
  end # class StringTemplate
end # LeafletHelper
