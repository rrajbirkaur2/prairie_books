class ApplicationController < ActionController::Base
  helper_method :current_cart

  def current_cart
    session[:cart_id] ||= nil
    @current_cart ||= Cart.find_by(id: session[:cart_id])

    if @current_cart.nil?
      @current_cart = Cart.create!(session_id: session.id.to_s)
      session[:cart_id] = @current_cart.id
    end

    @current_cart
  end
end