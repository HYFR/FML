require 'sequel'
require_relative './Menu.rb'

#relative dataset
@db = Sequel.sqlite('TheFML.db')

program = Menu.new(@db)
program.intro()
