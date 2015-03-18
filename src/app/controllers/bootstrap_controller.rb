class BootstrapController < ApplicationController
  protect_from_forgery
  include BootstrapHelper

  def index
    redirect_to "/worlds" unless World.count.zero?
  end

  def join_frame
    #puts params.inspect
  end

  def new_frame
    host_port = request.host_with_port
    hostname = host_port.split(":").first
    port = host_port.split(":").last
    create_frame hostname, port, params["name"], params["username"], params["email"], params["password"]
    redirect_to '/'
  end
end
