class Exceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)
    rescue => error
      @error = error
      @source_code = find_source(@error)
      @res = Rack::Response.new
      render(:error)
      @res.finish
    end
  end

  def render(template_name)
    file_path =
      "./../views/#{template_name}.html.erb"
    file_content = File.read(file_path)
    template = ERB.new(file_content)
    content = template.result(binding)
    render_content(content, "text/html")
  end

  def render_content(content, content_type)
    @res['Content-Type'] = content_type
    @res.write(content)
  end

  def find_source(error)
    path = error.backtrace.first
    file_path_regex = Regexp.new(/[^:]+/)
    line_number_regex = Regexp.new(/:\d+:/)
    file_path = file_path_regex.match(path).to_s
    @line_number = line_number_regex.match(path).to_s.delete(":").to_i
    File.readlines(file_path)
  end
end
