#!/usr/bin/ruby
require 'rubygems'
require 'sequel'

class DB
  # Try and connect to MySQL and create object
  def initialize(host, user, password, database, type)
    @db = Sequel.connect(:adapter=>type, :host=>host, :user=>user, :password=>password, :database=>database)
  end

  def query(query)
    query_output = @db.fetch(query)
    
    begin
      @newsletter = query_output.all
    rescue Sequel::DatabaseConnectionError
      abort("The database raised an error:\n" + $!)
    end

    # Returns an array of hashes
    # Keys are the column titles, values that row's data.
    return @newsletter
  end

  # Turn the database collection into a CSV
  def to_csv(newsletter_content)
    @newsletter_csv = []
    # Get the keys to use as CSV header
    @newsletter_csv.push(newsletter_content[0].keys.join(",")) 
    
    # Iterate over the array of hashes to get the values
    newsletter_content.each do |line|
      values = []
      # Extract the values
      line.each_pair do |key, value|
        values.push(value)
      end
      
      # Add each extracted line of values comma-separated
      @newsletter_csv.push(values.join(","))
    end

    return @newsletter_csv
  end

  # Close DB connexion
  def close
    @db.disconnect
  end
end
