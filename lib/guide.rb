require 'restaurant'
require './support/string_extend'

class Guide

  class Config

    @@actions = ['list', 'find', 'add', 'quit']

    def self.actions; @@actions; end

  end

  def initialize(path=nil)
    Restaurant.filepath = path
    if Restaurant.file_usable?
      puts "Restaurant file loaded"
    elsif Restaurant.create_file
      puts "Created restaurant file"
    else
      puts "Exiting"
      exit!
    end
  end

  def launch
    introduction
    result = nil
    until result == :quit
      action = get_action
      result = do_action(action)
    end
    conclusion
  end

  def get_action
    action = nil
    until Guide::Config.actions.include?(action)
      puts "Actions: " + Guide::Config.actions.join(", ") if action
      print "> "
      user_response = gets.chomp
      action = user_response.downcase.strip
    end
    return action
  end

  def do_action(action)
    case action
    when 'list'
      list
    when 'find'
      puts "finding"
    when 'add'
      add
    when 'quit'
      return :quit
    else
      puts "I don't understand your request"
    end
  end

  def add
    output_action_header("Add a restaurant")
    restaurant = Restaurant.build_using_questions
    if restaurant.save
      puts "Restaurant added"
    else
      puts "Error - restaurant not added"
    end
  end

  def list
    output_action_header("Listing Restaurants")
    restaurants = Restaurant.saved_restaurants
    output_restaurant_table(restaurants)
  end

  def introduction
    puts " <<<<< Welcome to Food Finder >>>>>>"
    puts "An interactive guide to help you find those fantastic food flavours you're craving!"
  end

  def conclusion
    puts " <<<<<< Farewell - come again soon! >>>>> "
  end

  private

  def output_action_header(text)
    puts "\n#{text.upcase.center(60)}\n\n"
  end

  def output_restaurant_table(restaurants=[])
    print " " + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    print " " + "Price".ljust(6) + "\n"
    puts "." * 60
    restaurants.each do |rest|
      line = " " << rest.name.titleize.ljust(30)
      line << " " + rest.cuisine.titleize.ljust(20)
      line << " " + rest.formatted_price.ljust(6)
      puts line
    end
    puts "No restaurants found" if restaurants.empty?
    puts "-" * 60
  end

end
