class ResponseBuilder
  attr_reader :response

  class Response
    attr_accessor :data, :code, :message
  end

  def initialize
    @response = Response.new
  end

  def set_data data
    @response.data = data
  end

  def set_code code
    @response.code = code
  end

  def set_message message
    @response.message = message
  end

  class << self
    def build
      builder = new
      yield builder
      builder.response
    end

    def build_success data
      build do |builder|
        builder.set_data data.serializable_hash[:data]
        builder.set_code 200
        builder.set_message :success
      end
    end

    def build_error message, code = 400
      build do |builder|
        builder.set_data nil
        builder.set_code code
        builder.set_message message
      end
    end
  end
end
