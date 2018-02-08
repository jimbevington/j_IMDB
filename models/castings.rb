require_relative('../db/sql_runner.rb')
require_relative('../models/movies.rb')


class Casting

  attr_reader :id
  attr_accessor :movie_id, :moviestar_id, :fee

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @movie_id = options['movie_id']
    @moviestar_id = options['moviestar_id']
    @fee = options['fee']
  end

  def calc_budget_deduction
    # calc deduction
    sql = "SELECT castings.fee FROM castings INNER JOIN moviestars
           ON castings.moviestar_id = moviestars.id
           WHERE castings.movie_id = $1"
    values = [@movie_id]
    result = SqlRunner.run(sql, values)
    fee_array = result.map{|movie| movie['fee'].to_i}
    deduction = if fee_array.length > 0
                  fee_array.sum
                else
                  0
                end
    return deduction
  end

  def update_film_budget_available
    deduction = calc_budget_deduction()
    movie_budget = Movie.find_by_id(@movie_id).budget
    new_sum = movie_budget.to_i - deduction.to_i
    sql = "UPDATE movies SET budget_available = $1 WHERE id = $2"
    values = [new_sum, @movie_id]
    SqlRunner.run(sql, values)
  end

  def save()
    sql = "INSERT INTO castings (movie_id, moviestar_id, fee)
           VALUES ($1, $2, $3) RETURNING id"
    values = [@movie_id, @moviestar_id, @fee]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
    update_film_budget_available()
  end

  def delete()
    sql = "DELETE FROM castings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE castings SET (movie_id, moviestar_id, fee) =
           ($1, $2, $3) WHERE id = $4"
    values = [@movie_id, @moviestar_id, @fee, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM castings"
    result = SqlRunner.run(sql)
    return result.map{|casting| Casting.new(casting)}
  end

  def self.delete_all()
    sql = "DELETE FROM castings"
    SqlRunner.run(sql)
  end

end
