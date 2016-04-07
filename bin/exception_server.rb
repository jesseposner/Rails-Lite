require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/exceptions'
require_relative '../lib/static_assets'

cat_app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

app = Rack::Builder.new do
  use Exceptions
  use StaticAssets
  run cat_app
end.to_app

class MyController < ControllerBase
  def go
    if @req.path == "/cats"
      render_content("hello cats!", "text/html")
    elsif @req.path == "/fail"
      fail
    end
  end
end

Rack::Server.start(
  app: app,
  Port: 3000
)
