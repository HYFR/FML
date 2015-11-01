require 'sequel'

DB = Sequel.sqlite('TheFML.db') #relative memory database

class User

  #Checks to see if a 'user' table exists in the FML database
  def verifyDB
    exist = DB.table_exists?(:user)
    if exist == true
      puts "There is a table named 'user' that exists. You have access to this table."
    else #Create a user table in the database
      DB.create_table :user do
        primary_key :user_id
        String :name
        String :password
      end
    end
    @@userAccount = DB[:user] # Creates a class variable dataset of the 'user' table.
  end

  def verifyAccount
    puts "Do you already have an account in the user database? "
    answer = gets.chomp.downcase

    if answer == "yes"
      puts "That is great. What is your username? "
      @@eusername = gets.chomp.downcase
      puts "And your password? "
      @@epassword = gets.chomp.downcase

      if @@userAccount.where(:name=>@@eusername).where(:password=>@@epassword).count > 0
        puts "Account exists."
        @@userID = @@userAccount.where(:name => @@eusername).where(:password => @@epassword).get(:user_id)

        puts "Would you like to delete your account?"
        
        danswer = gets.chomp.downcase

        if danswer == "yes"
          @@userAccount.delete()
          puts "Your account was deleted."
        else
          puts "Glad to have you stay with us."
        end
      else
        puts "The username or password is wrong."
        puts "Please try again."
        def tryAgain
          i = 0
          while i <= 3 do
            puts "You will be temporary kicked off if your password or username is incorrect three times."
            puts "What is your username?"
            username = gets.chomp.downcase
            puts "What is your password?"
            password = gets.chomp.downcase

            if @@userAccount.where(:name => username).where(:password => password).count == 1
              puts "Glad to have you with us."
            else
              puts "Username or password is wrong."
              i += 1
            end
          end
        end
      end
    elsif answer == "no"
      puts "You should consider joining."
    else
      puts "Type either 'yes' or 'no'."
    end
  end

  
=begin
  def tryAgain
    i = 0
    while i <= 3 do
      puts "You will be temporary kicked off if your password or username is incorrect three times."
      puts "What is your username?"
      username = gets.chomp.downcase
      puts "What is your password?"
      password = gets.chomp.downcase

      if @@userAccount.where(:name => username).where(:password => password).count == 1
        puts "Glad to have you with us."
      else
        puts "Username or password is wrong."
        i += 1
      end
    end
  end
=end
      
    
  def createUser
    puts "Since you do not have an account with us, would like to create an account?"
    answer = gets.chomp.downcase
    if answer == "yes"
      puts "What will be your username?"
      username = gets.chomp.downcase
      puts "What will be your password?"
      password = gets.chomp.downcase

      @@userAccount.insert(:name => username, :password => password)

    elsif answer == "no"
      puts "That's too bad. We'd like to have you join us."
    else
      puts "Type either 'yes' or no."
    end
  end

  def delAccount
    puts "Would you like to delete your account within the user database? "
    answer = gets.chomp.downcase

    if answer == "yes"
      userDataSet.delete()
      puts "Your account was successfully deleted"
    elsif answer == "no"
      puts "Glad to have you stay with us"
    else
      puts "Type either 'yes' or 'no'."
    end
  end
end


class Post < User

  def checkPostTable
    forumn = DB.table_exists?(:forum)
    if forumn == true
      puts "A forumn exists. You can post content onto this forumn."
    else
      DB.create_table :forum do
        primary_key :post_id
        foreign_key :user_id, :user
        String :title
        String :content
      end
    end
    @@currentPost = DB[:forum] # Creates a class variable from the forum table.
  end

  def createPost(accountID)
    
    puts "Would you like to create a post? "
    answer = gets.chomp.downcase

    if answer == "yes"
      puts "What would you like the title of your post to be? "
      title = gets.chomp

      puts "What would you like the content of your post to be? "
      content = gets.chomp
      
      #Fill the forumn table with a title and content
      @@currentPost.insert(:user_id => @@userID, :title => title, :content => content)
    elsif answer == "no"
      puts "You should consider joining us."
    else
      puts "Type either 'yes' or 'no'."
    end
  end

  def delPost
    puts "Would you like to delete your post?"
    answer == gets.chomp.downcase

    if answer == "yes"
      puts "Deleting your post."
      @@currentPost.delete()
    elsif answer == no
      puts "Understood, we will not delete your post."
    else
      puts "Type in either 'yes' or 'no'."
    end
  end
end

currentUser = User.new()
currentUser.verifyDB
currentUser.verifyAccount
currentUser.createUser
currentUser.delAccount

currentPost = Post.new()
currentPost.checkPostTable
currentPost.createPost(currentUser.verifyAccount)
