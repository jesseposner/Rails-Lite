require 'json'

class Session
  def initialize(req)
    if req.cookies["_rails_lite_app"]
      @cookie = JSON.parse(req.cookies["_rails_lite_app"])
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    json_cookie = JSON.generate(@cookie)
    cookie_attributes = {}
    cookie_attributes[:path] = "/"
    cookie_attributes[:value] = json_cookie
    res.set_cookie("_rails_lite_app", cookie_attributes)
  end
end
