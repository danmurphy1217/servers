#!/usr/bin/ruby
# included above for shell execution

require 'json';
require 'Httparty';
require 'sqlite3'

# a few constants...
params = ["econometrics+textbooks", "mysql+textbooks", "python+textbooks", "coding", "ruby+textbooks", "metacognition"]
db = SQLite3::Database.new ":memory:"


def handle_res( response )
=begin 
handle JSON response. This includes
looping through each book in the response
object and retrieving specific keys from
it (such as authors, title, page count 
and more).
=end
    response.each do |book|
        specifics = book['volumeInfo']
        final_specifics = check_nil( specifics )
        
        title = specifics['title']
        final_title = check_nil( title )
        
        authors = specifics['authors']
        final_authors = check_nil( authors )
        
        publisher = specifics['publisher']
        final_publisher = check_nil( publisher )

        published_date = specifics['publishedDate']
        final_published_date = check_nil( published_date )

        description = specifics['description']
        final_description = check_nil( description )

        pages = specifics['pageCount']
        final_pages = check_nil( pages )
        
        categories = specifics['categories']
        final_categories = check_nil( categories )

        avg_rating = specifics['averageRating']
        final_avg_rating = check_nil( avg_rating )

        return [
            final_title, 
            final_authors,
            final_publisher,
            final_published_date,
            final_description,
            final_pages,
            final_categories,
            final_avg_rating
        ]
    end
end

def check_nil( var )
    if !var.nil? and var.kind_of?(Array)
        return var.join(", ")
    else
        return var
    end
end

database_array = []

params.each do |param|
    url = "https://www.googleapis.com/books/v1/volumes?q=#{param}"
    response = HTTParty.get(url)
    json_response = response.parsed_response['items']
    database_array.push( handle_res( json_response ) )
end


def db_basics( db )
=begin
interacting with sqlite3. db is a 
sqlite3 database connection
=end
    puts db.get_first_value 'SELECT SQLITE_VERSION()'
   
    # check for db, throw errors if needed
    rescue SQLite3::Exception => e 
        puts "Exception occurred"
        puts e
    # close db
    ensure
        db.close if db
end

db_basics( db )

class Database
    def __init__(db_name, data)
        @db_name = db_name
        @data = data
    end
    def insert
        puts "I am a method for inserting data into tables in sqlite3."
        puts "database name is: #@db_name"
    end

    def create
        puts "I am a method for creating tables in sqlite3."
        puts "data is: #@data"
    end

end

p database_array


db = Database.new
# init database here
db.__init__("testdatabase1", "fake data")
# test reactive inputs
puts db.insert, db.create