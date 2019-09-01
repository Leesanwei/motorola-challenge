require 'sinatra'
require 'data_mapper'

DataMapper.setup :default, "sqlite://#{Dir.pwd}/db/radios.db"

class Radio
  include DataMapper::Resource
  property :id, Serial
  property :alias, String
  property :location, String

  has n, :locations, :through => Resource
end

class Location
  include DataMapper::Resource
  property :name, String, :key => true

  has n, :radios, :through => Resource
end


DataMapper.finalize

DataMapper.auto_upgrade!
