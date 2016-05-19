class StaticAssets
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    file_name = req.path[8..-1]

    if req.path.index("/public")
      res = build_response(file_name)
    else
      res = @app.call(env)
    end
  end

  private

  def build_response(file_name)
    res = Rack::Response.new

    case File.extname(file_name)
    when ".css"
      content_type = "text/css"
    when ".jpg"
      content_type = "image/jpeg"
    when ".png"
      content_type = "image/png"
    when ".svg"
      content_type = "image/svg+xml"
    when ".js"
      content_type = "application/javascript"
    when ".woff"
      content_type = "application/font-woff"
    when ".woff2"
      content_type = "application/font-woff2"
    end

    res["Content-type"] = content_type
    res.write(File.read("public/#{file_name}"))

    res
  end
end
