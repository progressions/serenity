require 'yaml'
# 
# Returns values from multi-level YAML configuration files.
# 
# Gracefully handles error messages when an option is not found.
#
# Usage:
#
#    Given config.yml:
#      name: Fred Flintstone
#      wife:
#        name: Wilma Flintstone
#      friend:
#        name: Barney Rubble
#        wife: Betty Rubble
#
#    @config = Serenity::Configuration.new("config.yml")
#
#    @config.get("name")            #=> "Fred Flinstone"
#    @config.get("wife", "name")    #=> "Wilma Flintstone"
# 
module Serenity
  class OptionNotFoundError < StandardError; end
    
  class Configuration
    attr_accessor :filename, :options
  
    def initialize(filename)
      @filename = filename
      @options = YAML.load_file(filename)
    end
  
    def to_hash
      options
    end
  
    def get(*args)
      c = options
    
      missing_option_index = 0
    
      args.each_with_index do |arg, i|
        if c.is_a?(Hash) && c.has_key?(arg)
          c = c[arg]
        else
          missing_option_index = i
          raise OptionNotFoundError
        end
      end
    
      c
    rescue OptionNotFoundError => e
      $stdout.puts "The following option was not found in #{filename}:"
      (0..missing_option_index).each do |i|
        $stdout.puts args[i]
      end
      $stdout.puts
      $stdout.puts "Are you sure #{filename} is up to date?"
      $stdout.puts
      raise e
    end
  end
end