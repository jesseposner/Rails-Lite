require 'rack'
require 'byebug'
require_relative '../lib/controller_base'

class MyController < ControllerBase
  def go
    if @req.path == "/flash"
      flash.now["new_now_test"] = "new now test"

      render_content("#{flash["cookie_test"]},
                      #{flash.now["old_now_test"]},
                      #{flash.now["new_now_test"]}",
                      "text/html")
    else
      flash["cookie_test"] = "cookie test"
      flash.now["old_now_test"] = "old now test"
      render_content("writing to flash", "text/html")
    end
  end
end
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
