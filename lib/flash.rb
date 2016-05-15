require 'json'

class Flash
  attr_reader :now

  def initialize(req, res)
    @now = {}
    @cookie = {}
    if req.cookies["flash"] && req.cookies["flash"] != ""
      @old_cookie = JSON.parse(req.cookies["flash"])
      res.set_cookie("flash", nil)
    end
  end

  def [](key)
    all_cookies = @old_cookie.merge(@cookie).merge(@now)
    all_cookies[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    json_cookie = JSON.generate(@cookie)
    cookie_attributes = {}
    cookie_attributes[:path] = "/"
    cookie_attributes[:value] = json_cookie
    res.set_cookie("flash", cookie_attributes)
  end
end
