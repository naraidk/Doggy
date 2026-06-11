class ErrorsController < ApplicationController
  layout "error"
  skip_before_action :authenticate_user!
  skip_before_action :ensure_has_dog

  def not_found
    render "404", status: :not_found
  end

  def internal_server_error
    render "500", status: :internal_server_error
  end
end
