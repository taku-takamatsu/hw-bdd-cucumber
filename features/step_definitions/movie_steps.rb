# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie[:title], :release_date => movie[:release_date], :rating => movie[:rating])
  end
  # pending "Fill in this step in movie_steps.rb"
end

Then /(.*) seed movies should exist/ do | n_seeds |
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  # https://stackoverflow.com/questions/4132758/cucumber-test-order-of-elements-in-table
  page.body.should =~ /#{e1}.*#{e2}/m
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  action = uncheck ? "uncheck" : "check"
  # Calling steps from web_steps.rb
  # Ref: https://stackoverflow.com/questions/918066/reuse-cucumber-steps
  rating_list.split(' ').each { |rating| 
    steps %Q{Then I #{action} "ratings_#{rating}"}
  }
end

# Part 2, Step 3
Then /^I should (not )?see the following movies: (.*)$/ do |no, movie_list|
  # Take a look at web_steps.rb Then /^(?:|I )should see "([^"]*)"$/
  if !no
    # see the movie list
    movie_list.split(',').each { |movie|
      steps %Q{Then I should see "#{movie}"}
    }
  else
    movie_list.split(',').each { |movie|
      steps %Q{Then I should not see "#{movie}"}
    }
  end

end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  # If you have computed rows as the number of table rows, 
  # you can use the assertion expect(rows).to eq value to fail the test in case the values don’t match.
  # https://stackoverflow.com/questions/2986250/how-to-assert-on-number-of-html-table-rows-in-ruby-using-capybara-cucumber
  all('table#movies tr').count == Movie.all.count
end

### Utility Steps Just for this assignment.

Then /^debug$/ do
  # Use this to write "Then debug" in your scenario to open a console.
   require "byebug"; byebug
  1 # intentionally force debugger context in this method
end

Then /^debug javascript$/ do
  # Use this to write "Then debug" in your scenario to open a JS console
  page.driver.debugger
  1
end


Then /complete the rest of of this scenario/ do
  # This shows you what a basic cucumber scenario looks like.
  # You should leave this block inside movie_steps, but replace
  # the line in your scenarios with the appropriate steps.
  fail "Remove this step from your .feature files"
end
