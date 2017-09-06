require 'dashing'

require 'sequel'
DBEX = Sequel.connect('postgres://postgres:postgres@localhost/exporter')
DB   = Sequel.connect('postgres://postgres:postgres@localhost/kromco')
# DB   = Sequel.connect('postgres://postgres:postgres@172.16.16.15/kromco_mes')

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  helpers do
    def protected!
      # Put any authentication code you want in here.
      # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
