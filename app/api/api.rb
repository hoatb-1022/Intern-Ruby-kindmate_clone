class API < Grape::API
  prefix :api
  format :json
  error_formatter :json, ErrorFormatter

  before do
    header["Access-Control-Allow-Origin"] = "*"
    header["Access-Control-Request-Method"] = "*"
  end

  mount Kindmate::Headers
  mount Kindmate::V1::Root

  add_swagger_documentation(
    hide_documentation_path: true,
    api_version: "v1",
    doc_version: "1.0",
    info: {
      title: "Kindmate Clone API",
      description: "Demo API docs for Kindmate Clone"
    }
  )
end
