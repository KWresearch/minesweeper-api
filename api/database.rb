require 'mongo'
require 'yaml'

class Database

  def initialize
    @config = YAML::load_file File.join(__dir__, 'config/config.yaml')
    @uri = @config[ENV['env'] || 'dev']['db']['uri']
  end

  def connect
    Mongo::Client.new(@uri)[:games]
  end
end