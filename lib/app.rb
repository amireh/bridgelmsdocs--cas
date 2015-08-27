require 'sinatra/base'
require_relative './cas_helpers'

class App < Sinatra::Base
  use Rack::Session::Cookie, secret: ENV['SECRET']

  helpers CasHelpers

  configure do
    set :public_folder, ENV['BRIDGELMSDOCS_ROOT']
  end

  before do
    process_cas_login(request, session)
  end

  get '/logout' do
    CASClient::Frameworks::Rails::Filter.logout(CasHelpers::Client)
  end

  not_found do
    require_authorization(request, session) unless logged_in?(request, session)
    File.read(File.join(settings.public_folder, "index.html"))
  end
end
