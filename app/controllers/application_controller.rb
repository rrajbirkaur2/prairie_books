class ApplicationController < ActionController::Base
  helper_method :current_cart
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_cart
    session[:cart_id] ||= nil
    @current_cart ||= Cart.find_by(id: session[:cart_id])

    if @current_cart.nil?
      @current_cart = Cart.create!(session_id: session.id.to_s)
      session[:cart_id] = @current_cart.id
    end

    @current_cart
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name, :address, :city, :postal_code, :province_id
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :name, :address, :city, :postal_code, :province_id
    ])
  end
end