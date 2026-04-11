# Seed Admin User
AdminUser.find_or_create_by(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end
puts "Seeded admin user"

# Seed Tags
tags = ["Classic", "Bestseller", "Award Winner", "New Release",
        "Staff Pick", "Sale", "Limited Stock", "Popular"]

tags.each do |tag_name|
  Tag.find_or_create_by(name: tag_name)
end
puts "Seeded #{Tag.count} tags"

# Seed Pages
Page.find_or_create_by(slug: "about").update(
  title: "About Us",
  content: "Prairie Books Online is a small independent bookstore located in Winnipeg, Manitoba. We have been serving our community for over 8 years, offering a wide selection of fiction, non-fiction, children's books, textbooks, and graphic novels. Our mission is to connect readers with great books and support a love of reading in our community."
)

Page.find_or_create_by(slug: "contact").update(
  title: "Contact Us",
  content: "We would love to hear from you! Visit us at 123 Main Street, Winnipeg, MB R3C 1A1. You can also reach us by phone at (204) 555-0100 or by email at info@prairiebooks.ca. Our store is open Monday to Saturday from 9am to 6pm and Sunday from 11am to 5pm."
)
puts "Seeded pages"

# Seed Provinces
provinces = [
  { name: "Alberta", gst: 0.05, pst: 0.00, hst: 0.00 },
  { name: "British Columbia", gst: 0.05, pst: 0.07, hst: 0.00 },
  { name: "Manitoba", gst: 0.05, pst: 0.07, hst: 0.00 },
  { name: "New Brunswick", gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: "Newfoundland and Labrador", gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: "Northwest Territories", gst: 0.05, pst: 0.00, hst: 0.00 },
  { name: "Nova Scotia", gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: "Nunavut", gst: 0.05, pst: 0.00, hst: 0.00 },
  { name: "Ontario", gst: 0.00, pst: 0.00, hst: 0.13 },
  { name: "Prince Edward Island", gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: "Quebec", gst: 0.05, pst: 0.09975, hst: 0.00 },
  { name: "Saskatchewan", gst: 0.05, pst: 0.06, hst: 0.00 },
  { name: "Yukon", gst: 0.05, pst: 0.00, hst: 0.00 }
]

provinces.each do |province|
  Province.find_or_create_by(name: province[:name]).update(province)
end
puts "Seeded #{Province.count} provinces"

# Seed Categories
categories = [
  { name: "Fiction", description: "Novels and stories from the imagination" },
  { name: "Non-Fiction", description: "Books based on real events and facts" },
  { name: "Children", description: "Books for young readers" },
  { name: "Textbooks", description: "Educational and academic books" },
  { name: "Graphic Novels", description: "Visual storytelling through comics and illustrations" }
]

categories.each do |category|
  Category.find_or_create_by(name: category[:name]).update(category)
end
puts "Seeded #{Category.count} categories"

# Seed Books
fiction = Category.find_by(name: "Fiction")
nonfiction = Category.find_by(name: "Non-Fiction")
children = Category.find_by(name: "Children")
textbooks = Category.find_by(name: "Textbooks")
graphic = Category.find_by(name: "Graphic Novels")

books = [
  { title: "The Midnight Library", author: "Matt Haig", description: "A novel about all the choices that go into a life well lived, set in a magical library between life and death.", price: 19.99, stock_quantity: 25, category: fiction },
  { title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams", description: "Seconds before Earth is demolished for a hyperspace bypass, Arthur Dent is swept off the planet by his friend Ford Prefect.", price: 14.99, stock_quantity: 30, category: fiction },
  { title: "Dune", author: "Frank Herbert", description: "Set in the distant future amidst a feudal interstellar society, Dune tells the story of young Paul Atreides.", price: 22.99, stock_quantity: 20, category: fiction },
  { title: "The Great Gatsby", author: "F. Scott Fitzgerald", description: "A story of the fabulously wealthy Jay Gatsby and his love for the beautiful Daisy Buchanan.", price: 12.99, stock_quantity: 40, category: fiction },
  { title: "To Kill a Mockingbird", author: "Harper Lee", description: "The story of racial injustice and the loss of innocence in the American South, seen through the eyes of young Scout Finch.", price: 13.99, stock_quantity: 35, category: fiction },
  { title: "1984", author: "George Orwell", description: "A dystopian novel set in a totalitarian society ruled by Big Brother, where Winston Smith dares to rebel.", price: 11.99, stock_quantity: 45, category: fiction },
  { title: "The Alchemist", author: "Paulo Coelho", description: "A philosophical novel about a young Andalusian shepherd who dreams of finding a worldly treasure.", price: 15.99, stock_quantity: 28, category: fiction },
  { title: "Pride and Prejudice", author: "Jane Austen", description: "A romantic novel following Elizabeth Bennet as she deals with issues of manners, upbringing, and marriage.", price: 10.99, stock_quantity: 50, category: fiction },
  { title: "Sapiens: A Brief History of Humankind", author: "Yuval Noah Harari", description: "A sweeping narrative of humanity's creation and evolution that explores the ways in which biology and history have defined us.", price: 21.99, stock_quantity: 22, category: nonfiction },
  { title: "Educated", author: "Tara Westover", description: "A memoir about a young girl who grows up in a survivalist family in rural Idaho and goes on to earn a PhD from Cambridge.", price: 18.99, stock_quantity: 18, category: nonfiction },
  { title: "Becoming", author: "Michelle Obama", description: "An intimate memoir by the former First Lady of the United States, covering her roots in Chicago to her years in the White House.", price: 24.99, stock_quantity: 15, category: nonfiction },
  { title: "The Body: A Guide for Occupants", author: "Bill Bryson", description: "A grand tour of the human body and how it functions, filled with wit and fascinating facts.", price: 20.99, stock_quantity: 20, category: nonfiction },
  { title: "Atomic Habits", author: "James Clear", description: "A proven framework for improving every day through tiny changes in behaviour that lead to remarkable results.", price: 22.99, stock_quantity: 33, category: nonfiction },
  { title: "Charlotte's Web", author: "E.B. White", description: "The story of a pig named Wilbur and his friendship with a barn spider named Charlotte who saves his life.", price: 9.99, stock_quantity: 60, category: children },
  { title: "The Very Hungry Caterpillar", author: "Eric Carle", description: "A caterpillar eats through a variety of foods before transforming into a beautiful butterfly.", price: 7.99, stock_quantity: 75, category: children },
  { title: "Harry Potter and the Philosopher's Stone", author: "J.K. Rowling", description: "The first book in the Harry Potter series, following a young boy who discovers he is a wizard.", price: 16.99, stock_quantity: 55, category: children },
  { title: "Where the Wild Things Are", author: "Maurice Sendak", description: "A classic picture book about a young boy named Max who is sent to his room without supper.", price: 8.99, stock_quantity: 40, category: children },
  { title: "Introduction to Algorithms", author: "Thomas H. Cormen", description: "A comprehensive textbook covering a broad range of algorithms in depth, widely used in university computer science courses.", price: 89.99, stock_quantity: 10, category: textbooks },
  { title: "Campbell Biology", author: "Lisa Urry", description: "The gold standard in introductory biology education, used by millions of students worldwide.", price: 129.99, stock_quantity: 8, category: textbooks },
  { title: "Calculus: Early Transcendentals", author: "James Stewart", description: "A classic calculus textbook known for its clarity of exposition and outstanding problem sets.", price: 109.99, stock_quantity: 12, category: textbooks },
  { title: "The Elements of Style", author: "William Strunk Jr.", description: "A prescriptive American English writing style guide covering the rules of usage and composition.", price: 9.99, stock_quantity: 30, category: textbooks },
  { title: "Maus", author: "Art Spiegelman", description: "A Pulitzer Prize-winning graphic novel depicting the Holocaust through the story of the author's father.", price: 17.99, stock_quantity: 20, category: graphic },
  { title: "Watchmen", author: "Alan Moore", description: "A deconstructionist take on superhero mythology set in an alternate 1985 America on the brink of nuclear war.", price: 19.99, stock_quantity: 18, category: graphic },
  { title: "Persepolis", author: "Marjane Satrapi", description: "An autobiographical graphic novel about growing up during the Islamic Revolution in Iran.", price: 15.99, stock_quantity: 22, category: graphic },
  { title: "V for Vendetta", author: "Alan Moore", description: "A dystopian political thriller set in a fascist future United Kingdom, following a masked vigilante known only as V.", price: 18.99, stock_quantity: 16, category: graphic }
]

books.each do |book|
  Book.find_or_create_by(title: book[:title]).update(book)
end
puts "Seeded #{Book.count} real books"

# Seed 100 additional books using Faker
require 'faker'

[ fiction, nonfiction, children, textbooks, graphic ].each do |category|
  20.times do
    title = Faker::Book.title + " " + rand(1000).to_s
    Book.find_or_create_by(title: title).update(
      author: Faker::Book.author,
      description: Faker::Lorem.paragraph(sentence_count: 4),
      price: Faker::Commerce.price(range: 9.99..89.99),
      stock_quantity: rand(5..50),
      category: category
    )
  end
end

puts "Total books seeded: #{Book.count}"
