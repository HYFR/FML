require 'sequel'

DB = Sequel.sqlite('TheFML.db') #relative memory database

class User
  def initialize
    @userDataset = DB[:user]
  end
  
  #Checks to see if a 'user' table exists in the FML database
  def verifyDB
    exist = DB.table_exists?(:user)
    if exist == true
    else #Create a user table in the database
      DB.create_table :user do
        primary_key :user_id
        String :name
        String :password
      end
    end
    @userDataset = DB[:user] # Creates a class variable dataset of the 'user' table.
  end

  def username
    puts "What is your username?"
    @username = gets.chomp.downcase
  end

  def password
    puts "What is your password?"
    @password = gets.chomp.downcase
  end

  def accountID()
    @accountID = @userDataset.where(:name => @username).where(:password => @password).get(:user_id)
    return @accountID
  end

  def logIN
    i = 0
    puts "You will be temporary kicked off if your password or username is incorrect three times."
    while i < 3 do
      @username = username()
      @password = password()

      if accountID() > 0
        puts "\nGlad to have you return, #{@username}. "
        i = 3
        return true
      else
        puts "Username or password is wrong."
        i += 1
      end
    end
  end
  
  def createUser
    @eusername = username()
    @epassword = password()

    @userDataset.insert(:name => @eusername, :password => @epassword)
    puts "\nThank you for joining us, '#{@eusername}'.\n "
  end

  def delAccount
    @username = username()
    @password = password()
    
    @userDataset.where(:name => @username).where(:password => @password).delete()
    puts "Your account, '#{@username}', was successfully deleted"
  end
end

class Post
  
  def checkPostTable
    forumn = DB.table_exists?(:forum)
    if forumn == true
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

  def createPost(id)
    
    #Fill the forumn table with a title and content
    puts "What would you like the title of your post to be? "
    @title = gets.chomp
    puts "What would you like the content of your post to be? "
    @content = gets.chomp
    @currentPost.insert(:user_id => id, :title => @title, :content => @content)
    puts "\nYour post, titled '#{@title}' was successfully created.\n "
  end

  def delPost()
    puts "#{@currentPost.where(:user_id => @user.userID).all}"
    puts "Your account's posts have been displayed. Type the Title of the post you want to delete."
    title = gets.chomp

    @currentPost.where(:title => title).delete()
    puts "\nThe post, titled  '#{title}' has been delted.\n "
  end

  def showPost()
    puts "#{@currentPost.all}"
    puts "\nThis is the post wall. It is a little messy at the moment but it will be cleanded up soon."
  end
end

class Menu
  def initialize
    @user = User.new
    @post = Post.new
    @user.verifyDB()
    @post.checkPostTable()
  end

  def intro()
    puts "Welcome to the forumn. Would you like to log in or create an account? Keywords are 'log in' or 'create'"
    answer = gets.chomp.downcase

    if answer == "log in"
      if @user.logIN()
        options()
      end
    elsif answer == "create"
      @user.createUser()
      options()
    end
  end
      
  
  def options()
    puts "\nWelcome to the DL forum. Here you can create a user account, create posts, and delete your account or posts. There are a few keywords you will have to keep in mind though: 'create post', 'delete user', 'delete post', 'show post', and 'exit'. Keep in mind that if you submit a word that is not a keyword you will be met with an error, asking for one of the keywords. Enjoy and have fun.\n\n*There is one thing to keep in mind though. If you want to delete your user account, you first have to delete any posts associated with the account.\n "
    puts "What would you like to do?"
    keyword = gets.chomp.downcase
    if keyword == "create post"
      @post.createPost(@user.accountID)
    elsif keyword == "delete user"
      @user.delAccount
    elsif keyword == "delete post"
      @post.delPost
    elsif keyword == "show post"
      @post.showPost()
    elsif keyword == "exit"
      abort("Exiting the DL forum. Thank you for coming")
    else
      puts "\nType in one of the keywords: 'create post', 'delete user', 'delete post', or 'exit \n'"
    end
    options()
  end
end

menu = Menu.new()
menu.intro()
