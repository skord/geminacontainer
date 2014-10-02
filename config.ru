require "rubygems"
require "geminabox"

Geminabox.data = "/data/geminabox-data" # ... or wherever
Geminabox.rubygems_proxy = true
Geminabox.allow_remote_failure = true

if ENV['PERMISSIONS_FLAVOR'].nil?
elsif ENV['PERMISSIONS_FLAVOR'] == 'PUBLIC_READ'
  return if (ENV['USERNAME'].nil? || ENV['PASSWORD'].nil?)
  Geminabox::Server.helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Geminabox")
        halt 401, "No pushing or deleting without auth.\n"
      end
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['USERNAME'], ENV['PASSWORD']]
    end
  end

  Geminabox::Server.before '/upload' do
    protected!
  end

  Geminabox::Server.before do
    protected! if request.delete?
  end

  Geminabox::Server.before '/api/v1/gems' do
    unless env['HTTP_AUTHORIZATION'] == 'API_KEY'
      halt 401, "Access Denied. Api_key invalid or missing.\n"
    end
  end
elsif ENV['PERMISSIONS_FLAVOR'] == "PRIVATE"
  return if (ENV['USERNAME'].nil? || ENV['PASSWORD'].nil?)
  use Rack::Auth::Basic, "GemInAbox" do |username, password|
    [username, password] == [ENV['USERNAME'], ENV['PASSWORD']]
  end
end

run Geminabox::Server
