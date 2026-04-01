namespace :import do
  desc "Import books from CSV file"
  task csv_books: :environment do
    require 'csv'

    csv_path = Rails.root.join('lib', 'data', 'books.csv')

    unless File.exist?(csv_path)
      puts "CSV file not found at #{csv_path}"
      exit
    end

    imported = 0
    skipped = 0

    CSV.foreach(csv_path, headers: true) do |row|
      category = Category.find_by(name: row['category'])

      unless category
        puts "Category not found: #{row['category']}, skipping..."
        skipped += 1
        next
      end

      next if Book.exists?(title: row['title'])

      Book.create!(
        title: row['title'],
        author: row['author'],
        description: row['description'],
        price: row['price'].to_f,
        stock_quantity: row['stock_quantity'].to_i,
        category: category
      )
      imported += 1
      print "."
    end

    puts "\nImported #{imported} books, skipped #{skipped}."
    puts "Total books now: #{Book.count}"
  end
end