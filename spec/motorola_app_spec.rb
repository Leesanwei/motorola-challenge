require './motorola_app.rb'
require 'rack/test'

describe 'Sinatra App' do
  include Rack::Test::Methods

  def app
    MotorolaApp.new
  end

  it "shows welcome message" do 
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq("Hello Motorola Solutions")
  end

  it "creates a radio with 2 locations" do
    h = {'Content-Type' => 'application/json'}
    body = { "alias": "Radio1", "allowed_locations": ["CPH-1", "CPH-2"] }.to_json
    post '/radios/1', body, h

    expect(last_response.status).to eq 200
    expect(Radio.get(1).locations.count).to eq(2)
  end

  it "return 403 FORBIDDEN if location is not in allowed locations" do
    h = {'Content-Type' => 'application/json'}
    body = { "location": "CPH-4" }.to_json
    post '/radios/1/location', body, h

    expect(last_response.status).to eq 403
  end

  it "returns 404 NOT FOUND if location has not been set" do
    get '/radios/1/location'

    expect(last_response.status).to eq 404
  end

  it "set the location if it is in allowed locations" do
    h = {'Content-Type' => 'application/json'}
    body = { "location": "CPH-1" }.to_json
    post '/radios/1/location', body, h

    expect(last_response.status).to eq 200
    expect(last_response.body).to eq("Radio 1 location has been set to CPH-1")
  end

  it "get the correct locaiton" do
    get '/radios/1/location'

    expect(last_response.body).to eq({"location":"CPH-1"}.to_json)
  end
end
