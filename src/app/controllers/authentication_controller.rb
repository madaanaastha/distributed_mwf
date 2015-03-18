class AuthenticationController < ApplicationController
  include WorldInstancesHelper
  protect_from_forgery

  def index
#     if session[:username].nil?
#       crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
#       unless (cookies[:username].nil?)
#         username = crypt.decrypt_and_verify(cookies[:username])
#         session[:username] = username
#       end
#     end
#     render :partial => "layouts/login"
  end

  def authenticate
    username = params["login"]
    password_hash = params["password_hash"]
    result_hash = {}
    unless (Uri.find_by_slug('Concept').is_external)
      uod_uri = Uri.find_by_slug('UniverseofDiscourse')
      user_table_uri = Uri.find_by_slug('User')
      users = DataTuple.where(world_uri: uod_uri.get_uri(), schema_uri: user_table_uri.get_uri()).select('data_store')
      users.each do |user|
        attrs_hash = user.data_hash
        if (attrs_hash[:username] == username)
          if (attrs_hash[:password_hash] == password_hash)
            result_hash[:username] = username
            result_hash[:email] = attrs_hash[:email]
            result_hash[:user_uri] = attrs_hash[:home_profile_uri]
            render text:result_hash.to_json and return
          end
        end
      end
    end
    head status: :forbidden
  end

  def login
    require 'uri'
    require 'net/http'

    Rails.cache.clear
    username = params["login"]
    password = params["password"].crypt("salt")
    unless (Uri.find_by_slug('Concept').is_external)
      uod_uri = Uri.find_by_slug('UniverseofDiscourse')
      user_table_uri = Uri.find_by_slug('User')
      users = DataTuple.where(world_uri: uod_uri.get_uri(), schema_uri: user_table_uri.get_uri()).select('data_store')
      users.each do |user|
        attrs_hash = user.data_hash
        if (attrs_hash[:username] == username)
          if (attrs_hash[:password_hash] == password)
            #TODO: update last login time in hash
            session[:username] = attrs_hash[:email]
            session[:user_uri] = attrs_hash[:home_profile_uri]
            crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
            user_cookie = {username: username, home_location_uri: attrs_hash[:home_profile_uri]}.inspect
            username = crypt.encrypt_and_sign(user_cookie)
            response.set_cookie(:user_id, {value: username, httponly: true, expires: 1.year.from_now})
            render :partial => "layouts/logout" and return
          end
        end
      end
      response.set_cookie(:user_id, {expires: Time.now})
      reset_session
      session[:username] = nil
      session[:user_uri] = nil
      flash[:notice] = "Invalid username or password."
      render :partial => "layouts/login"
    else
      host_uri = URI(World.find_by_name('Concept').home_location_uri)
      uri = URI::HTTP.build({host: host_uri.host, port:host_uri.port, path: '/authentication/authenticate',
                             query:"login=#{username}&password_hash=#{password}"})
      authentication_request = Net::HTTP::Get.new(uri.request_uri(),initheader = {'Content-Type' =>'application/json'})
      authentication_response = Net::HTTP.new(host_uri.host, host_uri.port).start {|http| http.request(authentication_request) }
      if(authentication_response.body)
        user_hash =  JSON.parse(authentication_response.body)
        puts '********************************************************************'
        puts user_hash.inspect
        puts '********************************************************************'
        session[:username] = user_hash['email']
        session[:user_uri] = user_hash['user_uri']
        username = user_hash['username']
        crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
        user_cookie = {username: username, home_location_uri: user_hash['user_uri']}.inspect
        username = crypt.encrypt_and_sign(user_cookie)
        response.set_cookie(:user_id, {value: username, httponly: true, expires: 1.year.from_now})
        render :partial => "layouts/logout" and return
      else
        response.set_cookie(:user_id, {expires: Time.now})
        reset_session
        session[:username] = nil
        session[:user_uri] = nil
        flash[:notice] = "Invalid username or password."
        render :partial => "layouts/login"
      end
    end
  end

  def logout
    Rails.cache.clear
    response.set_cookie(:user_id, {expires: Time.now})
    reset_session
    session[:username] = nil
    session[:user_uri] = nil
    render :partial => "layouts/login"
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:username] = user.email

    unless (Uri.find_by_slug('Concept').is_external)
      uod_uri = Uri.find_by_slug('UniverseofDiscourse')
      user_table_uri = Uri.find_by_slug('User')
      users = DataTuple.where(world_uri: uod_uri.get_uri(), role_uri: user_table_uri.get_uri()).select("data_store")
      users.each do |this_user|
        attrs_hash = this_user.data_hash
        if (attrs_hash[:email] == user.email)
          session[:user_uri] = attrs_hash[:home_profile_uri]
          break
        end
      end
      if (session[:user_uri].nil?)
        host_with_port = request.host_with_port
        hostname = host_with_port.split(':').first
        port = host_with_port.split(':').last
        person = add_user(hostname, port, user.name, user.email, user.email, 'rootset')
        session[:user_uri] = person.world_instance_uri
      end
    end

    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    user_cookie = {username: session[:username], home_location_uri: session[:user_uri]}.inspect
    username = crypt.encrypt_and_sign(user_cookie)
    response.set_cookie(:user_id, {value: username, httponly: true, expires: 1.year.from_now})

    redirect_to root_url
  end

  def check_user
    code = :ok
    unless (World.count.zero?)
      uod_uri = Uri.find_by_slug('UniverseofDiscourse')
      user_table_uri = Uri.find_by_slug('User')

      users = DataTuple.where(world_uri: uod_uri.get_uri, role_uri: user_table_uri.get_uri).select("data_store")
      users.each do |user|
        attrs_hash = user.data_hash
        if (attrs_hash[:username]==params["username"])
          code = :bad_request
          break
        end
      end
    end
    head code
  end
end
