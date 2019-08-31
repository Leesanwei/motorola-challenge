require 'sinatra'

class MotorolaApp < Sinatra::Base
  get "/" do
    "Hello World"
  end
end