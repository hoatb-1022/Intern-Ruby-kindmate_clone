class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html{render status: :not_found}
    end
  end

  def unacceptable
    respond_to do |format|
      format.html{render status: :unprocessable_entity}
    end
  end

  def internal_error
    respond_to do |format|
      format.html{render status: :internal_server_error}
    end
  end
end
