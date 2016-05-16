require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './flash'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @params = req.params.merge(route_params)
    @req = req
    @res = res
    flash
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "double render" if @already_built_response
    @res.header["location"] = url
    @res.status = 302
    @already_built_response = true
    session.store_session(@res)
    flash.store_session(@res)
  end

  def render_content(content, content_type)
    raise "double render" if @already_built_response
    @res['Content-Type'] = content_type
    @res.write(content)
    @already_built_response = true
    session.store_session(@res)
    flash.store_session(@res)
  end

  def render(template_name)
    file_path =
      "./../views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    file_content = File.read(file_path)
    template = ERB.new(file_content)
    content = template.result(binding)
    render_content(content, "text/html")
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req, @res)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless @already_built_response
  end
end
