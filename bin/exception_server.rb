require 'rack'

app = Rack::Builder.new do
  # XXX:
end

Rack::Server.start(
  app: app,
  Port: 3000
)
