module Kindmate
  class Headers < Grape::API
    format :json

    namespace :headers do
      desc "Returns a header value"
      params do
        requires :key, type: String
      end
      get ":key" do
        key = params[:key]

        if headers[key].present?
          ResponseBuilder.build_success key => headers[key]
        else
          ResponseBuilder.build_error I18n.t("api.headers.unknown_key")
        end
      end

      desc "Returns all headers"
      get do
        ResponseBuilder.build_success headers
      end
    end
  end
end
