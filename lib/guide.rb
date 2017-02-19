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
      action, args = get_action
      result = do_action(action, args)
    end
    conclusion
  end

  def get_action
    action = nil
    until Guide::Config.actions.include?(action)
      puts "Actions: " + Guide::Config.actions.join(", ") if action
      print "> "
      user_response = gets.chomp
      args = user_response.downcase.strip.split(' ')
      action = args.shift
    end
    return action, args
  end

  def do_action(action, args=[])
    case action
    when 'list'
      list(args)
    when 'find'
      keyword = args.shift
      find(keyword)
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

  def list(args=[])
    sort_order = args.shift
    sort_order = args.shift if sort_order == 'by'
    sort_order = "name" unless ['name', 'cuisine', 'price'].include?(sort_order)
    output_action_header("Listing Restaurants")
    restaurants = Restaurant.saved_restaurants
    restaurants.sort! do |r1, r2|
      case sort_order
      when 'name'
        r1.name.downcase <=> r2.name.downcase
      when 'cuisine'
        r1.cuisine.downcase <=> r2.cuisine.downcase
      when 'price'
        r1.price.to_i <=> r2.price.to_i
      end
    end
    output_restaurant_table(restaurants)
    puts "Sort using: 'list cuisine' or 'list by cuisine'\n\n"
  end

  def find(keyword="")
    output_action_header("Find a restaurant")
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |rest|
        rest.name.downcase.include?(keyword.downcase) ||
        rest.cuisine.downcase.include?(keyword.downcase) ||
        rest.price.to_i <= keyword.to_i
      end
      output_restaurant_table(found)
    else
      puts "Find using a key word to search the restaurant"
      puts "Examples: 'Find Pobno', 'Find fancy pants', 'find fancy'\n\n"
    end

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
