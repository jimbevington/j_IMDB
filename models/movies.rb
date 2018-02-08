require_relative('../db/sql_runner.rb')

class Movie

  attr_reader :id
  attr_accessor :title, :genre, :rating, :budget, :budget_available

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @rating = options['rating']
    @budget = options['budget']
    # if created with a budget availabe field, use that, otherwise just
    # initialize with the budget.
    @budget_available = unless options['budget_available']
                          @budget
                        else
                          options['budget_available']
                        end
  end

  def save()
    sql = "INSERT INTO movies (title, genre, rating, budget, budget_available) VALUES ($1, $2, $3, $4, $5) RETURNING id"
    values = [@title, @genre, @rating, @budget, @budget_available]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def delete()
    sql = "DELETE FROM movies WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE movies SET (title, genre, rating, budget, budget_available) = ($1, $2, $3, $4, $5)
           WHERE id = $6"
    values = [@title, @genre, @rating, @budget, @budget_available, @id]
    SqlRunner.run(sql, values)
  end

  def cast()
    sql = "SELECT moviestars.* FROM moviestars INNER JOIN castings
           ON moviestars.id = castings.moviestar_id
           WHERE castings.movie_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map{|movie| MovieStar.new(movie)}
  end

  def budget_remaining
    sql = "SELECT castings.fee FROM castings INNER JOIN moviestars
           ON castings.moviestar_id = moviestars.id
           WHERE castings.movie_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    fees_array = result.map{|casting| casting['fee'].to_i }
    if fees_array.length > 0
      deduction = fees_array.sum
      return @budget - deduction
    else
      return @budget
    end
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM movies WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    return Movie.new(result[0])
  end

  def self.all()
    sql = "SELECT * FROM movies"
    movies = SqlRunner.run(sql)
    return movies.map{|movie| Movie.new(movie)}
  end

  def self.delete_all()
    sql = "DELETE FROM movies"
    SqlRunner.run(sql)
  end


  #

end
