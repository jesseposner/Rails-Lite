# Rails Lite

Rails Lite is a web application framework inspired by Ruby on Rails.

## Instructions

Define the controller's actions in `bin/server.rb`. The http request can be accessed via the `@req` instance variable and the response can be accessed via the `@res` instance variable. The parameters can be accessed via the `@params` instance variable. The path can be accessed by calling `@req.path`.

The `render_content` method accepts two arguments: (1) the content and (2) the content type. The `render` method takes a single argument, the name of an `erb` file in the `view` directory. The `redirect_to` method also takes a single argument, a path.

Here's a simple example controller:

```ruby
class Controller < ControllerBase
  @cats = [
    { id: 1, name: "Curie" },
    { id: 2, name: "Markov" }
  ]

  def go
    if @req.path == "/cats"
      render_content(@cats.to_json, "application/json")
    elsif @req.path == "/"
      render :index
    else
      redirect_to("/cats")
    end
  end
end
```
