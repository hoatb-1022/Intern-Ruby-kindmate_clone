Grape::Jwt::Authentication.configure do |conf|
  conf.rsa_public_key_caching = true
  conf.rsa_public_key_expiration = 1.hour

  conf.jwt_issuer = "Kindmate"
  conf.jwt_beholder = "kindmate-api"

  conf.malformed_auth_handler = proc do |raw_token, app|
    raise ArgumentError, "Authorization header is malformed"
  end

  conf.failed_auth_handler = proc do |token, app|
    raise ArgumentError, "Access denied"
  end

  conf.jwt_options = proc do
    {algorithm: "HS256"}
  end

  conf.jwt_verification_key = proc do
    Rails.application.secrets.secret_key_base
  end

  conf.authenticator = proc do |token|
    jwt = Grape::Jwt::Authentication::Jwt.new(token)
    jwt.access_token? && jwt.valid?
  end
end
