require 'rails/application/route_inspector'

def display_routes
  Rails.application.reload_routes!
  routes = Rails.application.routes.routes
  inspector = Rails::Application::RouteInspector.new
  puts inspector.format(routes, ENV['CONTROLLER']).join "\n"
end
