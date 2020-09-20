#!/usr/bin/ruby
# included above for shell execution

require 'json';
require 'httparty';
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
        p "Parsing Google Books response..."
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
    p "Sending request for #{(param.split("+").join(" "))}"
    url = "https://www.googleapis.com/books/v1/volumes?q=#{param}"
    response = HTTParty.get(url)
    json_response = response.parsed_response['items']
    json_response.each do |item|
        database_array.push( handle_res( json_response ) )
    end
end

p "Working with the db now..."

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

# db_basics( db )

class Database
    def __init__(db_name, data)
        @db_name = db_name
        @data = data
    end
    def insert
        # id 1 already exists in the db, so start here...
        id = 0
        @data.each do |obj|
            db = SQLite3::Database.open "ruby.db"
            id += 1
            title = obj[0]
            authors = obj[1]
            publisher = obj[2]
            description = obj[4].to_s.delete("'")
            pg_count = obj[5].to_i
            category = obj[6]
            avg_rating = obj[7].to_f

            p "Inserting Data"
            db.execute "INSERT INTO Books (`id`, `Title`, `Authors`,`Publisher`, `Description`, `PageCount`, `Category`, `AvgRating` ) VALUES( #{id}, \"#{title}\", \"#{authors}\", \"#{publisher}\", \"#{description}\", #{pg_count}, \"#{category}\", #{avg_rating} )"
        rescue SQLite3::Exception => e 
            puts "Exception occurred"
            puts e
        ensure
            db.close if db
        end
    end
    
    def create
        db = SQLite3::Database.open "ruby.db"
        db.execute "CREATE TABLE IF NOT EXISTS Books(
                id INTEGER PRIMARY KEY, Title TEXT, Authors TEXT, Publisher TEXT, Description TEXT,
                PageCount INTEGER, Category TEXT, AvgRating REAL)"
        p "Tables created if it wasn't already."
    end

end


db = Database.new
# init database here
db.__init__("testdatabase1", database_array)
# test reactive inputs
db.create
db.insert