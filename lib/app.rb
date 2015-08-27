require_relative './cas_helpers'

configure do
  use Rack::Session::Cookie, secret: ENV['SECRET']

  helpers CASHelpers

  set :public_folder, ENV['BRIDGELMSDOCS_ROOT']
end

before do
  process_cas_login(request, session)
end

not_found do
  if params[:ticket]
    return redirect '/'
  end

  require_authorization(request, session) unless logged_in?(request, session)
  File.read(File.join(settings.public_folder, "index.html"))
end
