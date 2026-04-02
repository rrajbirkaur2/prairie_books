class ApplicationController < ActionController::Base
  helper_method :current_cart, :breadcrumbs, :add_breadcrumb
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :track_visit_count

  def current_cart
    session[:cart_id] ||= nil
    @current_cart ||= Cart.find_by(id: session[:cart_id])
    if @current_cart.nil?
      @current_cart = Cart.create!(session_id: session.id.to_s)
      session[:cart_id] = @current_cart.id
    end
    @current_cart
  end

  def breadcrumbs
    @breadcrumbs ||= [{ name: "Home", path: root_path }]
  end

  def add_breadcrumb(name, path = "#")
    breadcrumbs << { name: name, path: path }
  end

  private

  def track_visit_count
    session[:visit_count] ||= 0
    session[:visit_count] += 1
    session[:last_visited] = Time.now.to_s
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