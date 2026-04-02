class CheckoutController < ApplicationController
  before_action :set_cart
  before_action :ensure_cart_not_empty

  def new
    if user_signed_in? && current_user.province.present?
      redirect_to confirm_checkout_path
    end
  end

  def create
    province = Province.find(params[:province_id])
    session[:checkout] = {
      province_id: province.id,
      address: params[:address],
      city: params[:city],
      postal_code: params[:postal_code]
    }
    redirect_to confirm_checkout_path
  end

  def confirm
    add_breadcrumb "Cart", cart_path
    add_breadcrumb "Checkout", new_checkout_path
    add_breadcrumb "Review Order"

    @checkout = session[:checkout] || {}

    if user_signed_in? && current_user.province.present?
      @province = current_user.province
      @address = current_user.address
      @city = current_user.city
      @postal_code = current_user.postal_code
    elsif @checkout["province_id"].present?
      @province = Province.find(@checkout["province_id"])
      @address = @checkout["address"]
      @city = @checkout["city"]
      @postal_code = @checkout["postal_code"]
    else
      redirect_to new_checkout_path, alert: "Please provide your address."
      return
    end

    @cart_items = @cart.cart_items.includes(:book)
    @subtotal = @cart.total_price
    @gst = (@subtotal * @province.gst).round(2)
    @pst = (@subtotal * @province.pst).round(2)
    @hst = (@subtotal * @province.hst).round(2)
    @grand_total = (@subtotal + @gst + @pst + @hst).round(2)
    @stripe_publishable_key = Rails.application.credentials.dig(:stripe, :publishable_key)
  end

  def complete
    @checkout = session[:checkout] || {}

    if user_signed_in? && current_user.province.present?
      province = current_user.province
      address = current_user.address
      city = current_user.city
      postal_code = current_user.postal_code
    elsif @checkout["province_id"].present?
      province = Province.find(@checkout["province_id"])
      address = @checkout["address"]
      city = @checkout["city"]
      postal_code = @checkout["postal_code"]
    else
      redirect_to new_checkout_path
      return
    end

    subtotal = @cart.total_price
    gst = (subtotal * province.gst).round(2)
    pst = (subtotal * province.pst).round(2)
    hst = (subtotal * province.hst).round(2)
    grand_total = (subtotal + gst + pst + hst).round(2)

    begin
      charge = Stripe::Charge.create(
        amount: (grand_total * 100).to_i,
        currency: "cad",
        source: params[:stripeToken],
        description: "Prairie Books Order - #{current_user&.email}"
      )

      order = Order.create!(
        user: current_user,
        province: province,
        address: address,
        city: city,
        postal_code: postal_code,
        status: "paid",
        subtotal: subtotal,
        gst_rate: province.gst,
        pst_rate: province.pst,
        hst_rate: province.hst,
        gst_amount: gst,
        pst_amount: pst,
        hst_amount: hst,
        grand_total: grand_total,
        total_price: grand_total,
        stripe_payment_id: charge.id
      )

      @cart.cart_items.each do |item|
        order.order_items.create!(
          book: item.book,
          quantity: item.quantity,
          price_at_purchase: item.price_at_purchase
        )
      end

      @cart.cart_items.destroy_all
      session[:checkout] = nil
      @order = order
      flash[:notice] = "Payment successful! Order ##{order.id} placed."

    rescue Stripe::CardError => e
      flash[:alert] = "Payment failed: #{e.message}"
      redirect_to confirm_checkout_path
    rescue Stripe::StripeError => e
      flash[:alert] = "Payment error: #{e.message}"
      redirect_to confirm_checkout_path
    end
  end

  private

  def set_cart
    @cart = current_cart
  end

  def ensure_cart_not_empty
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty!"
    end
  end
end
