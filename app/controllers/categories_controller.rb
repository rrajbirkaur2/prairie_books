class CategoriesController < ApplicationController
  def index
    @categories = Category.all.includes(:books)
  end

  def show
    @category = Category.find(params[:id])
    @categories = Category.all
    @books = @category.books.order(created_at: :desc).page(params[:page]).per(12)
  end
end
