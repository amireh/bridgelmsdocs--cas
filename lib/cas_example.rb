require 'sinatra/base'
require 'cas_helpers'

class CasExample < Sinatra::Base
  use Rack::Session::Cookie, :secret => 'changed'

  helpers CasHelpers

  configure do
    set :public_folder, ENV['BRIDGELMSDOCS_ROOT']
  end

  before do
    process_cas_login(request, session)
  end

  get "/protected" do
    require_authorization(request, session) unless logged_in?(request, session)

    "you are logged in as #{session[:cas_user]}"
  end

  not_found do
    require_authorization(request, session) unless logged_in?(request, session)
    File.read(File.join(settings.public_folder, "index.html"))
  end
end
