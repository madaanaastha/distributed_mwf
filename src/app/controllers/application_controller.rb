class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :verify_user_login

  def verify_user_login
    unless(cookies[:username].nil?)
      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
      user_cookie = eval(crypt.decrypt_and_verify(cookies[:user_id]))
      session[:username] = user_cookie[:username]
      session[:user_uri] = user_cookie[:home_location_uri]
    end unless session[:username].nil?
  end
end
