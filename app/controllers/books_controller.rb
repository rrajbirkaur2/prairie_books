class BooksController < ApplicationController
  def index
    @categories = Category.all
    @books = Book.includes(:category)

    if params[:search].present?
      @books = @books.where(
        "title ILIKE ? OR description ILIKE ?",
        "%#{params[:search]}%",
        "%#{params[:search]}%"
      )
    end

    if params[:category_id].present?
      @books = @books.where(category_id: params[:category_id])
    end

    case params[:filter]
    when "on_sale"
      @books = @books.on_sale
    when "new"
      @books = @books.new_arrivals
    when "recently_updated"
      @books = @books.recently_updated
    end

    @books = @books.order(created_at: :desc).page(params[:page]).per(12)
  end

  def show
    @book = Book.find(params[:id])
  end
end
