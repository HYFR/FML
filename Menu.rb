require_relative './User'
require_relative './Post'
require_relative './Comment'

class Menu

  def initialize(db)
    @db = db
    @user = User.new(@db)
    @post = Post.new(@db)
  end
                   
  def username
    puts "What is your username?"
    @username = gets.chomp.downcase
  end

  def password
    puts "What is your password?"
    @password = gets.chomp.downcase
  end

  def logIN()
    #tracks number of attempts to log in
    logINattempt = 0
    puts "\n\tYou will be temporary kicked off if your password or username is incorrect three times. If by any chance you are here by mistake, type exit as your username and password, and you will be returned towards the forum menu.\n "
    while logINattempt < 3 do
      if @user.accountID(username, password)
        puts "\nGlad to have you return, #{@username}. "
        logINattempt = 3
        return true
      elsif @username == "exit" && @password == "exit"
        intro()
      else
        puts "Username or password is wrong."
        logINattempt += 1
      end
    end
  end

  def createUser()
    @user.insert(username, password)

    puts "\nThank you for joining us, #{@username}.\n "
  end

   #Menu to log in or create account
  def intro()
    puts "\tWelcome to the forumn. Would you like to log in or create an account? Keywords are 'log in' or 'create' or 'exit'.\n"
    answer = gets.chomp.downcase
    if answer == "log in"
      if logIN()
        options()
      end
    elsif answer == "create"
      createUser()
      options()
    elsif answer == "exit"
      puts "Later"
      exit
    else
      puts "Type either 'log in' or 'create'\n"
      intro()
    end
  end

  #Menu for most of the features
  def options()
    puts "\n\tWelcome to the DL forum. Here you can create posts, and delete your account or posts. There are a few keywords you will have to keep in mind though: 'create post', 'delete user', 'delete post', 'show post', 'log out', or 'comment.' Keep in mind that if you submit a word that is not a keyword you will be met with an error, asking for one of the keywords. Enjoy and have fun.\n\n"
    keyword = gets.chomp.downcase
    if keyword == "create post"
      @post.createPost(@user.accountID(@username, @password))
    elsif keyword == "delete user"
      @comment.delUsrComment(@user.accountID(@username, @password))
      @post.delUsrPost(@user.accountID(@username, @password))
      @user.delAccount(@username, @password)
    elsif keyword == "delete post"
      @post.delPost(@user.accountID(@username, @password))
    elsif keyword == "show post"
      @post.showPost(@user.accountID(@username, @password))
    elsif keyword == "log out"
      puts "Logging out, #{@username}.\n"
      intro()
    else
      puts "\nType in one of the keywords: 'create post', 'show post', 'delete user', 'delete post', or 'log out\n'"
    end
    options()
  end
end
