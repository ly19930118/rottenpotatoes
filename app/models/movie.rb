class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  
  def self.find_all_ratings
      return ['G','PG','PG-13','R'].to_enum
  end

end