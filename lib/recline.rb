# This is a base class for each resource. What you would do
# is build patterns on top of this resource, such as a 
# collection/item resource, or even Rails' pattern for
# how they do resources.

class BaseResource
  attr_accessor :name, :urls, :methods, :representations

  # This first calls the method for the specific URL (if it
  # exists), then it calls the method for the HTTP method 
  # that is being called.
  #
  # Look at `task_resources.rb` for the TasksResource example.
  # In it, you will see a @urls attribute that looks like:
  #
  #  @urls = {
  #     :default => '/tasks',
  #     :completed => '/tasks/completed'
  #  }
  # 
  # This means before every request to `/tasks`, the :default
  # method on the class is called. After that the method is 
  # called that corresponds to the HTTP method, which is derived
  # from the @methods attribute on the resource.

  def url(url, method, request, params)
    send(url, request, params) if respond_to? url
    send(method, request, params) if respond_to? method
  end
end

# Registers the resource with the proper URLs and methods
# It first loops through the URLs, then creates the available
# methods for each.
#
# A better way to do this might be to check to see if a
# resource supports a resource, either by having a method
# on the class that is the name of the HTTP method (such as `get`
# like in my examples) or listed in the @methods attribute
# as an alias (to allow you to map `get` to `show`).

def register_resource(resource)
  base = resource.new

  base.urls.each do |url_name, url|
    base.methods.each do |http_method, resource_method|
      # This would include all HTTP methods. I just have 
      # `GET` for simplicity
      case http_method
      when :get
        get url do
          # Just supporting json for this example. Content negotiation
          # would need to be done somewhere in this library
          content_type 'application/json'
          return base.url(url_name, resource_method, request, params)
        end
      end
    end
  end
end

# If I were to build more patterns here, I may have some like this:
#
# register_collection
# register_item
# register_resources - to do it how Rails does it