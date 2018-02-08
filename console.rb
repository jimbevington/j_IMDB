require('pry-byebug')

require_relative('./models/castings.rb')
require_relative('./models/movies.rb')
require_relative('./models/moviestars.rb')

Casting.delete_all()
MovieStar.delete_all()
Movie.delete_all()


movie1 = Movie.new({
    'title' => 'Drive',
    'genre' => 'thriller',
    'rating' => 4,
    'budget' => 5000000
})
movie2 = Movie.new({
    'title' => 'Blade Runner 2049',
    'genre' => 'sci-fi',
    'rating' => 4,
    'budget' => 1200000
})
movie3 = Movie.new({
    'title' => 'Get Out!',
    'genre' => 'horror',
    'rating' => 5,
    'budget' => 100000
})
movie4 = Movie.new({
  'title' => 'Blade Runner',
  'genre' => 'sci-fi',
  'rating' => 5,
  'budget' => 3450000
})
movie5 = Movie.new({
  'title' => 'Witness',
  'genre' => 'thriller',
  'rating' => 3,
  'budget' => 2340000
})

movies = [movie1, movie2, movie3, movie4, movie5]

# save all the movies
for movie in movies
  movie.save()
end


moviestar1 = MovieStar.new({
    'first_name' => 'Ryan',
    'last_name' => 'Gosling'
})
moviestar2 = MovieStar.new({
    'first_name' => 'Daniel',
    'last_name' => 'Kaluuya'
})
moviestar3 = MovieStar.new({
    'first_name' => 'Harrison',
    'last_name' => 'Ford'
})

moviestars = [moviestar1, moviestar2, moviestar3]

for star in moviestars
  star.save()
end

# RG in BR2049
casting1 = Casting.new({
  'movie_id' => movie2.id,
  'moviestar_id' => moviestar1.id,
  'fee' => 1000000
})
# HF in BR2049
casting2 = Casting.new({
  'movie_id' => movie2.id,
  'moviestar_id' => moviestar3.id,
  'fee' => 2500000
})
# RG in Drive
casting3 = Casting.new({
  'movie_id' => movie1.id,
  'moviestar_id' => moviestar1.id,
  'fee' => 1500000
})
# HF in BR
casting4 = Casting.new({
  'movie_id' => movie4.id,
  'moviestar_id' => moviestar3.id,
  'fee' => 15000
})
# HF in Witness
casting5 = Casting.new({
  'movie_id' => movie5.id,
  'moviestar_id' => moviestar3.id,
  'fee' => 15000
})
casting6 = Casting.new({
  'movie_id' => movie3.id,
  'moviestar_id' => moviestar2.id,
  'fee' => 75000
})

castings = [casting1, casting2, casting3, casting4, casting5, casting6]

for casting in castings
  casting.save()
end



binding.pry
nil
