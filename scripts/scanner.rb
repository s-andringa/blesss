require "rubygems"
require "tweetstream"
require "yaml"
require "active_support/core_ext/hash"

require File.expand_path("../app/models/person", File.dirname(__FILE__))

tsconfig = YAML.load_file(File.expand_path("../config/tweetstream.yml", File.dirname(__FILE__)))['development']
tsconfig.symbolize_keys!
tsconfig[:auth_method] = :oauth

TweetStream::Client.new(tsconfig).track('bless', 'blesss', 'blezz', 'blezzz') do |status|
  if status.text =~ /ble[sz]{2,}.*(@[\w-]+)/i
    Person.bless($1)
    print "#{$1} was blessed! => #{status.text}\n"
  else
    print "No blessing.\n"
  end
end