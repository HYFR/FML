require 'sequel'
require_relative './Post.rb'
require_relative './Comment.rb'
require_relative './Menu.rb'
require_relative './User.rb'

DB = Sequel.sqlite('TheFML.db') #relative memory database

class ProgramControl
  def initialize
    @menu = Menu.new
  end

  def startProgram
    @menu.intro()
  end
end

program = ProgramControl.new()
program.startProgram()
