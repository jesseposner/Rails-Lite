class StaticAssets
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    image_file = req.path[8..-1]
    if req.path.match(/^\/public/) && image_file != ""
      @res = Rack::Response.new
      render(image_file)
      @res.finish
    else
      app.call(env)
    end
  end

  def render(image_name)
    file_path =
      "public/#{image_name}"
    file_content = File.read(file_path)
    render_content(file_content, "image/jpeg")
  end

  def render_content(content, content_type)
    @res['Content-Type'] = content_type
    @res.write(content)
  end
end
