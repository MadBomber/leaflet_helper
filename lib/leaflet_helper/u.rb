# u.rb
# This is a utility class

module LeafletHelper
  class U
    class << self

      # insert HTML/JS or whatever from a file in the lib/templates directory
      # use ERB to pre-process the file using local binding
      def pull_in(template_name, options={})
        options.each { |k,v| instance_variable_set("@#{k}", v) }

        puts "="*65
        print "pull_in(#{template_name}) option keys: "
        puts options.keys.join(', ')
        puts "="*65

        @file_name = LeafletHelper::TEMPLATES + template_name
        return ERB.new(@file_name.read, 0, '>').result(binding)
      end # def pull_in(template_name, options={})

    end # class << self
  end # class U
end # module LeafletHelper
