namespace :import do
  desc "Import books from CSV file"
  task csv_books: :environment do
    require "csv"

    csv_path = Rails.root.join("lib", "data", "books.csv")

    unless File.exist?(csv_path)
      puts "CSV file not found at #{csv_path}"
      exit
    end

    imported = 0
    skipped = 0

    CSV.foreach(csv_path, headers: true, liberal_parsing: true) do |row|
      next if row["title"].blank?
      next if row["category"].blank?

      category = Category.find_by(name: row["category"]&.strip)

      unless category
        puts "Category not found: #{row['category']}, skipping..."
        skipped += 1
        next
      end

      next if Book.exists?(title: row["title"])

      Book.create!(
        title: row["title"].truncate(200),
        author: row["author"]&.truncate(200) || "Unknown",
        description: row["description"] || "No description available.",
        price: row["price"].to_f,
        stock_quantity: row["stock_quantity"].to_i,
        category: category
      )
      imported += 1
      print "."
    end

    puts "\nImported #{imported} books, skipped #{skipped}."
    puts "Total books now: #{Book.count}"
  end
end