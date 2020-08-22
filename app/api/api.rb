class API < Grape::API
  prefix :api
  format :json
  error_formatter :json, ErrorFormatter

  mount Kindmate::Headers
  mount Kindmate::V1::Root
end
