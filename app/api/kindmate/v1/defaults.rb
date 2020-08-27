module Kindmate
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        version "v1"
        format :json

        include Grape::Jwt::Authentication
        auth :jwt
      end
    end
  end
end
