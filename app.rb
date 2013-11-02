require 'sinatra'

require './recline'
require './task_resources'

# Register your resources here. This makes your resources
# very modular since you can just require and register a
# resource in any application you build.

register_resource(TasksResource)



