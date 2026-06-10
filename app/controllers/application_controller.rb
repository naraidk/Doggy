class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_has_dog
  helper_method :current_dog

  def current_dog
    if session[:current_dog_id].present?
      current_user.dogs.find_by(id: session[:current_dog_id])
    else
      current_user.dogs.first
    end
  end

  private

  def ensure_has_dog
    return unless current_user
    return if current_user.dogs.any?
    return if devise_controller?
    return if params[:controller] == 'dogs' || params[:controller] == 'rails/health'
    redirect_to new_dog_path, notice: "Commencez par créer le profil de votre chien !"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username])
  end

    def skip_pundit?
      devise_controller? ||
        params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
    end
end
