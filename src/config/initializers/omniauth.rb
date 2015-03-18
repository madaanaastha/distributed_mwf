OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '519759143189-fp0m0om5fu47ai81gfhgpi5dve7jej1n.apps.googleusercontent.com', '_IJ5Z2BNBlHjI-vD6WL5b5B_', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end