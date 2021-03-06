require 'sinatra'
require 'dropbox_sdk'
require 'digest/md5'

configure do
  set :app_key, ENV["app_key"]
  set :app_secret, ENV["app_secret"]
  set :access_type, :app_folder

  set :access_token, ENV["access_token"]
  set :access_secret, ENV["access_secret"]
end

before do
  session = DropboxSession.new(settings.app_key, settings.app_secret)
  session.set_access_token(settings.access_token, settings.access_secret)
  @client = DropboxClient.new(session, settings.access_type)
end

post '/' do
  data = request[:imagedata][:tempfile].read
  hash = Digest::MD5.hexdigest(data)
  file = @client.put_file("#{hash}.png", data)
  @client.shares(file["path"])["url"]
end
