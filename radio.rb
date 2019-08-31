require 'sinatra'
require 'data_mapper'

DataMapper.setup :default, "sqlite://#{Dir.pwd}/db/radios.db"

class Radio
    include DataMapper::Resource
    property :id, Serial
    property :alias, String
    property :allowed_locations, Object
  end

DataMapper.finalize

Radio.auto_upgrade!