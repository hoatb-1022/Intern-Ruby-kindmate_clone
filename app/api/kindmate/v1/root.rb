module Kindmate
  module V1
    class Root < Grape::API
      mount Kindmate::V1::UserEndpoints
      mount Kindmate::V1::CampaignEndpoints

      resource :payload do
        desc "A JWT payload echo service."
        get do
          {payload: request_jwt.payload.to_h}
        end
      end

      resource :token do
        desc "A JWT echo service"
        get do
          {token: original_request_jwt}
        end
      end

      include Grape::Jwt::Authentication
      auth :jwt
    end
  end
end
