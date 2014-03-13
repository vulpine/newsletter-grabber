#!/usr/bin/ruby
require 'yaml'
require 'db'

# Read the config, win a prize
config_file = './config.yaml'
if File.exist? config_file
  config_file = YAML::load(File.open(config_file))
else
  abort "No config found! (Looking in #{config_file})"
end

# Use an argument to determine which newsletter to get
key = ARGV[0]

# Is it configured?
if !config_file[key]
  abort "'#{key}' doesn't appear to be configured in #{config_file}!"
end

# Extract useful variables from config file
config = config_file[key]
name = config['name']
database = config['database']
username = config['user']
password = config['password']
host = config['host']
query = config['query']
type = config['type']

# Instantiate DB connection
db = DB.new(host, username, password, database, type)

# Get the query result
newsletter_content = db.query(query)

# Make a CSV of it
puts db.to_csv(newsletter_content)

# Housekeeping
db.close
