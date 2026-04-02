class PagesController < ApplicationController
  def home
    @featured_books = Book.order(created_at: :desc).limit(8)
    @categories = Category.all
  end

  def about
    @page = Page.find_by(slug: "about")
  end

  def contact
    @page = Page.find_by(slug: "contact")
  end
end