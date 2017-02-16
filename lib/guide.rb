class Guide

  def initialize(path=nil)
  end

  def launch
    introduction
    conclusion
  end

  def introduction
    puts " <<<<< Welcome to Food Finder >>>>>>"
    puts "An interactive guide to help you find those fantastic food flavours you're craving!"
  end

  def conclusion
    puts " <<<<<< Farewell - come again soon! >>>>> "
  end

end
