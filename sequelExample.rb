require 'sequel'

DB = Sequel.sqlite('/home/japhet/Desktop/Database Programming (Ruby)/TheDL.db') # memory database

exist = DB.table_exists?(:user)
if exist == true
  puts "There is a table named 'user' that exists. You have access to this table."
else
  # Creates a table named user in the database
  DB.create_table :user do
    primary_key :user_id
    String :name
    String :password
  end
end



account = DB[:user] # Create a dataset

puts "Do you already have an account in the user database? "
answer = gets.chomp.downcase

if answer == "yes"
  puts "That is great. What is your username? "
  eusername = gets.chomp.downcase
  puts "And your password? "
  epassword = gets.chomp.downcase

# code some lines that check if the username and password exist in the DB.
else if answer == "no"
  puts "What will be your username? "
  username = gets.chomp.downcase
  puts "What will be your password? "
  password = gets.chomp.downcase

  #Fill table with user input based on user input
  account.insert(:name => username, :password => password)
else puts "Answer 'yes' or 'no'"
end


puts "Would you like to delete your account within the user database? "
answer = gets.chomp.downcase


if answer == "yes"
  account.delete()
  puts "Your account was successfully deleted"
else
  puts "Glad to have you stay with us"
end

forumn = DB.table_exists?(:forumn)
if forumn == true
  puts "A forumn exists. You can post content onto this forumn."
else
  DB.create_table :forumn do
    foreign_key :user_id, :user
    String :title
    String :content
  end
end



dirtyLaundry = DB[:forumn] # Create a dataset for the forumn table
    

puts "Would you like to create a post? "
posta = gets.chomp.downcase

if posta == "yes"
  puts "What would you like the title of your post to be? "
  title = gets.chomp

  puts "What would you like the content of your post to be? "
  content = gets.chomp

  #Fill the forumn table with a title and content
  dirtyLaundry.insert(:title => title, :content => content)
  
else if posta == "no"
  puts "As of now there is nothing else to do. Good day."
else puts "Please type either 'yes' or 'no'. Thank you."
end
end
end
