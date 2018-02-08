require_relative('../db/sql_runner.rb')

class MovieStar

  attr_reader :id
  attr_accessor :first_name, :last_name

  def initialize(options)
    # @id = options['id'].to_i if options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
  end

  def save()
    sql = "INSERT INTO moviestars (first_name, last_name) VALUES ($1, $2)
           RETURNING id"

    values = [@first_name, @last_name]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def delete()
    sql = "DELETE FROM moviestars WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE moviestars SET (first_name, last_name) = ($1, $2)
           WHERE id = $3"
    values = [@first_name, @last_name, @id]
    SqlRunner.run(sql, values)
  end

  def movies()
    sql = "SELECT movies.* FROM movies INNER JOIN castings
           ON movies.id = castings.movie_id WHERE castings.moviestar_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map{|movie| Movie.new(movie)}
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM moviestars WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    return MovieStar.new(result[0])
  end

  def self.all
    sql = "SELECT * FROM moviestars"
    stars = SqlRunner.run(sql)
    return stars.map{|star| MovieStar.new(star)}
  end

  def self.delete_all
    sql = "DELETE FROM moviestars"
    SqlRunner.run(sql)
  end

end
