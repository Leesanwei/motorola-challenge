require 'sinatra'
require './model.rb'

class MotorolaApp < Sinatra::Base
  before do
    next unless request.post?
    @payload = JSON.parse(request.body.read)
  end

  get '/' do
    "Hello Motorola Solutions"
  end

  post '/radios/:id' do
    radio = Radio.first_or_create(:id => params[:id],:alias => @payload["alias"])
    @payload["allowed_locations"].each do |allowed_location|
      location = Location.first_or_create(:name => allowed_location)
      radio.locations << location
    end
    radio.save
  end

  post '/radios/:id/location' do
    radio = Radio.get(params[:id])
    halt 403 unless radio
    location = Location.get(@payload["location"])

    if radio.locations.include? location 
      radio.update(:location => @payload["location"])
      [200, "Radio #{radio.id} location has been set to #{radio.location}"]
    else
      [403, "FORBIDDEN "]
    end
  end

  get '/radios/:id/location' do
    radio = Radio.get(params[:id])
    if radio.location
        [200, { location: radio.location }.to_json]
    else
        [404, "NOT FOUND"]
    end
  end
end