MIGRATIONS_ROOT = File.expand_path(File.join(File.dirname(__FILE__),  'migrations'))
require 'spec'
require 'spec/autorun'
require "database_connection"
require 'octopus'

Spec::Runner.configure do |config|  
  config.mock_with :rspec

  config.before(:each) do
    Octopus.stub!(:directory).and_return(File.dirname(__FILE__))
    require "database_models"
    clean_all_shards()
  end

  config.after(:each) do
    clean_all_shards()
  end
end

def clean_all_shards()
  ActiveRecord::Base.using(:master).connection.shards.keys.each do |shard_symbol|
    ['schema_migrations', 'users', 'clients', 'cats', 'items'].each do |tables|
      ActiveRecord::Base.using(shard_symbol).connection.execute("DELETE FROM #{tables};") 
    end
  end
end