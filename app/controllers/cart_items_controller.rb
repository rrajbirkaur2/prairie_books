class CartItemsController < ApplicationController
  before_action :set_cart
  before_action :set_cart_item, only: [:update, :destroy]

  def create
    book = Book.find(params[:book_id])
    existing_item = @cart.cart_items.find_by(book: book)

    if existing_item
      existing_item.increment!(:quantity)
      flash[:notice] = "✓ Added another copy of '#{book.title}' to your cart!"
    else
      @cart.cart_items.create!(
        book: book,
        quantity: 1,
        price_at_purchase: book.price
      )
      flash[:notice] = "✓ '#{book.title}' has been added to your cart!"
    end

    redirect_back(fallback_location: books_path)
  end

  def update
    new_quantity = params[:quantity].to_i
    if new_quantity > 0
      @cart_item.update!(quantity: new_quantity)
      flash[:notice] = "✓ Cart updated successfully!"
    else
      @cart_item.destroy
      flash[:notice] = "✓ Item removed from your cart!"
    end
    redirect_to cart_path
  end

  def destroy
    book_title = @cart_item.book.title
    @cart_item.destroy
    flash[:notice] = "✓ '#{book_title}' has been removed from your cart!"
    redirect_to cart_path
  end

  private

  def set_cart
    @cart = current_cart
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  end
end