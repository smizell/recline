require 'json'

# Some sample data for the Tasks

TASKS = [
  {
    id: 1,
    task: "Get milk",
    completed: true
  },
  {
    id: 2,
    task: "Drink milk",
    completed: false
  },
  {
    id: 2,
    task: "Refrigerate Milk",
    completed: false
  }
]

# Just a little utility to convert
# strings to booleans.

def to_boolean(string)
  string == 'true'
end

class TasksResource < BaseResource

  def initialize
    # The name of our link relation
    @name = 'r:tasks'

    # The URLs for this resource, and their corresponding
    # methods. The reason I have multiple URLs for this
    # resource is because each of these URLs returns this
    # specific resource when requested. The data may be different,
    # but the resource type is the same.
    @urls = {
      :default => '/tasks',
      :completed => '/tasks/completed',
      :filter => '/tasks/filter'
    }

    # Available HTTP methods and what class methods
    # they correspond with, so you could change this to
    # whatever suits your needs
    @methods = {
      :get => 'get'
    }

    # This would be used to handle content negotiations
    # I know there is the respond_with contrib library
    # that could be used for this. Right now, this is just
    # here for example.
    @representations = [:html, :json]
  end

  # This is called first whenever the :default URL is
  # requested

  def default(request, params)
    @tasks = TASKS
  end 

  # This is called first whenever the :completed URL is
  # requested.

  def completed(request, params)
    @tasks = TASKS.select do |task|
      task[:completed]
    end
  end

  # This is called first whenever the :filter URL is
  # requested. As mentioned below, I could call this
  # before every request if I wanted to give me filtering
  # on any URL for this resource.

  def filter(request, params)
    @tasks = TASKS.select do |task|
      task[:completed] == to_boolean(params[:completed])
    end
  end

  # Lots could be done here. Right now, I'm simply responding
  # with json, but content negotiation should happen either 
  # here or in the `url` method in the BaseResource class. 

  def get(request, params)
    # If I wanted to add filtering to all URLs, I could call
    # that method here (or I could create some `before_filter`)
    #
    # filter(request, params)
    @tasks.to_json
  end
end