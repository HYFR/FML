require 'sequel'

DB = Sequel.sqlite('TheFML.db') #relative memory database

class User
  def initialize()
  end

  #Checks to see if a 'user' table exists in the FML database
  def create
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
    $userAccount = DB[:user] # Create a global dataset of the 'user' table
  end

  def userInput
    puts "Do you already have an account in the user database? "
    answer = gets.chomp.downcase

    if answer == "yes"
      puts "That is great. What is your username? "
      eusername = gets.chomp.downcase
      puts "And your password? "
      epassword = gets.chomp.downcase

      if $userAccount.where(:name=>eusername).where(:password=>epassword).count
        puts "Account exists."
      else
        puts "The username or password is wrong."
        puts "Please try again."
        exit
      end
      

    # code some lines that check if the username and password exist in the DB.
    else if answer == "no"
      puts "What will be your username? "
      username = gets.chomp.downcase
      puts "What will be your password? "
      password = gets.chomp.downcase

      #Fill table with user input based on user input
      $userAccount.insert(:name => username, :password => password)
    else puts "Answer 'yes' or 'no'"
    end


    puts "Would you like to delete your account within the user database? "
    answer = gets.chomp.downcase

    if answer == "yes"
      $userAccount.delete()
      puts "Your account was successfully deleted"
    else
      puts "Glad to have you stay with us"
    end
  end
end
end

class Forum
  def initialize
  end

  def checkOrCreate
    forumn = DB.table_exists?(:forum)
    if forumn == true
      puts "A forumn exists. You can post content onto this forumn."
    else
      DB.create_table :forum do
        primary_key :post_id
        many_to_one :user, :key=>:user_id
        foreign_key :user_id, :user
        String :title
        String :content
      end
    end
    $currentPost = DB[:forum] # Create a global dataset for the forumn table
  end

  def createPost
    puts "Would you like to create a post? "
    posta = gets.chomp.downcase

    if posta == "yes"
      puts "What would you like the title of your post to be? "
      title = gets.chomp

      puts "What would you like the content of your post to be? "
      content = gets.chomp

      #Fill the forumn table with a title and content
      $currentPost.insert(:title => title, :content => content)

      puts "Would you like to delete your post?"
      dpost = gets.chomp.downcase

      if dpost == "yes"
        puts "Deleting your post."
        $currentPost.delete()
      else if dpost == "no"
        puts "Understood, we will not delete your post."
      else
        puts "Type either 'yes' or 'no'."
      end
    end

    else if posta == "no"
      "Okay, we will not delete your post. As of now there is nothing left o do. The program will exit."

    else
      puts "Print either 'yes' or 'no'."
  end
end
end
end
  

currentUser = User.new()
currentUser.create
currentUser.userInput

currentPost = Forum.new()
currentPost.checkOrCreate
currentPost.createPost

#forumn.method(database)
