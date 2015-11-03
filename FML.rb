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

      # user input gets stored into a class instance variable and stored into DB
      if @@userAccount.where(:name=>@@eusername).where(:password=>@@epassword).count > 0
        puts "Account exists."
        @@userID = @@userAccount.where(:name => @@eusername).where(:password => @@epassword).get(:user_id)

        puts "Would you like to delete your account?"
        danswer = gets.chomp.downcase

        puts "What is your username?"
        dusername = gets.chomp

        if danswer == "yes"
          @@userAccount.where(:name => dusername).delete()
          puts "Your account was deleted."
        elsif danswer == "no"
          puts "Glad to have you stay with us."
        else
          puts "Type in either 'yes' or 'no.'"
        end
      else
        puts "The username or password is wrong."
        puts "Please try again."
      end
    elsif answer == "no"
      puts "You should consider joining."
    else
      puts "Type either 'yes' or 'no'."
    end
  end

  def tryAgain
    i = 0
    puts "You will be temporary kicked off if your password or username is incorrect three times."
    while i < 3 do
      puts "What is your username?"
      @username = gets.chomp.downcase
      puts "What is your password?"
      @password = gets.chomp.downcase

      # The .count method returns a number and if the number is > 0, the int signifies the number of accounts that exist with the specific @username and @password. if int returned from .count > 0 then an account exists.
      if @@userAccount.where(:name => @username).where(:password => @password).count > 0
        puts "Glad to have you with us."
        i = 3
      else
        puts "Username or password is wrong."
        i += 1
      end
    end
  end
  
  def createUser
    puts "Since you do not have an account with us, would like to create an account?"
    answer = gets.chomp.downcase
    if answer == "yes"
      puts "What will be your username?"
      @@eusername = gets.chomp.downcase
      puts "What will be your password?"
      @@epassword = gets.chomp.downcase

      @@userAccount.insert(:name => @@eusername, :password => @@epassword)

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
      @@userAccount.where(:name => @@eusername).where(:password => @@epassword).delete()
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
    @@currentPost = DB[:forum] # Creates a class variable from the forum table that holds a Post dataset.
  end

  def createPost(accountID)
    puts "Would you like to create a post? "
    answer = gets.chomp.downcase

    if answer == "yes"
      puts "What would you like the title of your post to be? "
      @@title = gets.chomp

      puts "What would you like the content of your post to be? "
      @@content = gets.chomp
      
      #Fill the forumn table with a title and content
      @@currentPost.insert(:user_id => @@userID, :title => @@title, :content => @@content)
    elsif answer == "no"
      puts "You should consider joining us."
    else
      puts "Type either 'yes' or 'no'."
    end
  end

  def delPost
    puts "#{@@currentPost.where(:user_id => @@userID).all}"
    puts "Your account's posts have been displayed. Type the Title of the post you want to delete."
    title = gets.chomp

    puts "LAST WARNING: Would you like to delete this post?"
    deletion = gets.chomp.downcase

    if deletion == "yes"
      puts "Deleting your post."
      @@currentPost.where(:title => title).delete()
    elsif deletion == "no"
      puts "Understood, we will not delete your post."
    else
      puts "Type in either 'yes' or 'no'."
    end
  end
end

# Create an instance of User class and verify that every method works.
currentUser = User.new()
currentUser.verifyDB
currentUser.verifyAccount
currentUser.createUser
currentUser.tryAgain
currentUser.delAccount

# Create an isntance of Post class and verify that every method works
currentPost = Post.new()
currentPost.checkPostTable
currentPost.createPost(currentUser.verifyAccount) 
currentPost.delPost
