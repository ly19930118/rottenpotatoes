# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #flunk "Unimplemented"
  within('table[id=movies]') do
    collected_movies = all('td[id=movie_title]').collect(&:text)
    assert collected_movies.index(e1) < collected_movies.index(e2)
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rlst = rating_list.split(',')
  
  rlst.each do |r|
    if uncheck
      steps %Q{
        When I uncheck "ratings_#{r}"
      } 
    else
      steps %Q{
        When I check "ratings_#{r}"
      } 
    end
  end
end

When /^I press Refresh$/ do
  # Write code here that turns the phrase above into concrete actions
  steps %Q{
    When I press "Refresh"
  }
end

Then /I should see movies with ratings: (.*)/ do |rating_list|
  # Write code here that turns the phrase above into concrete actions
  within('table[id=movies]') do
    collected_ratings = all('td[id=movie_rating]').collect(&:text)
    rating_list.split(',').each do |r|
      assert collected_ratings.include? r
    end
  end
end

Then /I should not see movies with ratings: (.*)/ do |rating_list|
  # Write code here that turns the phrase above into concrete actions
  within('table[id=movies]') do
    collected_ratings = all('td[id=movie_rating]').collect(&:text)
    rating_list.split(',').each do |r|
      assert collected_ratings.exclude? r
    end
  end
end

Given(/^I check all the ratings: G,PG,PG\-(\d+),R$/) do |arg1|
  # Write code here that turns the phrase above into concrete actions
  steps %Q{
    When I check the following ratings: G,PG,PG-13,R
    And I press Refresh
  } 
end
Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  expected_size = Movie.all.count
  within('table[id=movies]') do
    collected_movies_size = all('td[id=movie_title]').collect(&:text).size
    assert(collected_movies_size == expected_size, collected_movies_size.to_s + " does not equal " + expected_size.to_s)
  end
end