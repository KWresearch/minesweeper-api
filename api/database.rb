require 'singleton'
require 'mongo'
require 'yaml'

class Database
  include Singleton

  attr_reader :db

  def initialize
    @config = YAML::load_file File.join(__dir__, 'config/config.yaml')
    @uri = ENV['DB_URI'] || @config[@config['mode']]['db']['uri']
    @db = Mongo::Client.new(@uri)[:games]
  end
end