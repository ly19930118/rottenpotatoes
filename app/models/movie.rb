class Movie < ActiveRecord::Base
  attr_accessible :title, :director, :rating, :description, :release_date,
  
  def self.find_all_ratings
      return ['G','PG','PG-13','R'].to_enum
  end

  def find_same_director_movies
      Movie.where('id != ? AND director = ?', id, director)
  end
end