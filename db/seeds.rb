# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Movie.destroy_all
Bookmark.destroy_all
List.destroy_all

require 'open-uri'
require 'json'

def add_movies_to_db(movies_list)
  movies_list.each do |movie|
    p movie
    Movie.create!(title: movie['title'], overview: movie['overview'], poster_url: "https://image.tmdb.org/t/p/orginal/#{movie['poster_path']}", rating: movie['vote_average'])
  end
end

url = "http://tmdb.lewagon.com/movie/top_rated?page="
page = 1
movie_request = JSON.parse(URI.open("#{url}#{page}").read)
add_movies_to_db(movie_request["results"])
# results for list of results. page for page number. total_pages = 438
total_pages = 1
# total_pages = movie_request["total_pages"]
while page < total_pages
  page += 1
  puts "Fetching page: #{page}"
  new_movie_request = JSON.parse(URI.open("#{url}#{page}").read)
  add_movies_to_db(new_movie_request["results"])
end
