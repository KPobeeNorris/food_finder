require 'restaurant'

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
      puts "listing"
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
    puts "Add a restaurant".upcase
    restaurant = Restaurant.new

    print "Restaurant name: "
    restaurant.name = gets.chomp.strip

    print "Restaurant cuisine: "
    restaurant.cuisine = gets.chomp.strip

    print "Enter average dish price: "
    restaurant.price = gets.chomp.strip

    if restaurant.save
      puts "Restaurant added"
    else
      puts "Error - restaurant not added"
    end
  end

  def introduction
    puts " <<<<< Welcome to Food Finder >>>>>>"
    puts "An interactive guide to help you find those fantastic food flavours you're craving!"
  end

  def conclusion
    puts " <<<<<< Farewell - come again soon! >>>>> "
  end

end
