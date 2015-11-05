require 'sequel'

DB = Sequel.sqlite('TheFML.db') #relative memory database

class User
  
  #Checks to see if a 'user' table exists in the FML database
  def verifyDB
    exist = DB.table_exists?(:user)
    if exist == true
      puts "User table exists"
    else #Create a user table in the database
      DB.create_table :user do
        primary_key :user_id
        String :name
        String :password
      end
    end
    @userDataset = DB[:user] # Creates a class variable dataset of the 'user' table.
  end

  def userID
    puts "What is your username?"
    @username = gets.chomp.downcase

    puts "What is your password?"
    @password = gets.chomp.downcase

    @userID = @userDataset.where(:name => @username).where(:password => @password).get(:user_id)
    return @userID
  end

  def verifyAccount
    puts "Do you already have an account in the user database? "
    answer = gets.chomp.downcase

    if answer == "yes"
      puts "That is great. What is your username? "
      @eusername = gets.chomp.downcase
      puts "And your password? "
      @epassword = gets.chomp.downcase 

      # user input gets stored into a class instance variable and stored into DB
      if @userDataset.where(:name=>@eusername).where(:password=>@epassword).count > 0
        puts "Account exists."
        @userID = @userDataset.where(:name => @eusername).where(:password => @epassword).get(:user_id)
    elsif answer == "no"
      puts "You should consider joining."
    else
      puts "Type either 'yes' or 'no'."
      end
    end
    return @userID
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
      if @userAccount.where(:name => @username).where(:password => @password).count > 0
        puts "Glad to have you with us."
        i = 3
      else
        puts "Username or password is wrong."
        i += 1
      end
    end
  end
  
  def createUser
    puts "What will be your username?"
    @eusername = gets.chomp.downcase
    puts "What will be your password?"
    @epassword = gets.chomp.downcase

    @userDataset.insert(:name => @eusername, :password => @epassword)
    puts "\nThank you for joining us #{@eusername}.\n "
  end

  def delAccount
    puts "Would you like to delete your account within the user database? "
    answer = gets.chomp.downcase

    if answer == "yes"
      @userAccount.where(:name => @eusername).where(:password => @epassword).delete()
      puts "Your account was successfully deleted"
    elsif answer == "no"
      puts "Glad to have you stay with us"
    else
      puts "Type either 'yes' or 'no'."
    end
  end
end

class Post
  
  def initialize
    @user = User.new()
    @verify = @user.verifyDB()
  end
  
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
    @currentPost = DB[:forum] # create a instance variable of the dataset 'forum'
  end

  def createPost()
    puts "What would you like the title of your post to be? "
    @title = gets.chomp

    puts "What would you like the content of your post to be? "
    @content = gets.chomp
      
    #Fill the forumn table with a title and content
    @currentPost.insert(:user_id => @user.userID, :title => @title, :content => @content)
    puts "\nYour post, titled '#{@title}' was successfully created.\n "
  end

  def delPost()
    puts "#{@currentPost.where(:user_id => @user.userID).all}"
    puts "Your account's posts have been displayed. Type the Title of the post you want to delete."
    title = gets.chomp

    @currentPost.where(:title => title).delete()
    puts "\nThe post, titled  '#{title}' has been delted.\n "
  end
end

class Menu
  def initialize
    @user = User.new
    @post = Post.new
    @user.verifyDB()
    @post.checkPostTable()
  end
  
  def options()
    puts "Welcome to the DL forum. Here you can create a user account, create posts, and delete your account or posts. There are a few keywords you will have to keep in mind though: 'create user', 'create post', 'delete user', 'delete post', and 'exit'. Keep in mind that if you submit a word that is not a keyword you will be met with an error, asking for one of the keywords. Enjoy and have fun."
    puts "What would you like to do?"
    keyword = gets.chomp.downcase
    if keyword ==  "create user"
      @user.createUser()
      options()
    elsif keyword == "create post"
      @post.createPost()
      options()
    elsif keyword == "delete user"
      @user.delAccount
      options()
    elsif keyword == "delete post"
      @post.delPost
      options()
    elsif keyword == "exit"
      abort("Exiting the DL forum. Thank you for coming")
    else
      puts "\nType in one of the keywords: 'create user', 'create post', 'delete user', 'delete post', or 'exit \n'"
      options()
    end
  end
end

menu = Menu.new()
menu.options()
