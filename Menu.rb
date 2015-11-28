class Menu

  def initialize
    @user = User.new
    @post = Post.new
    @comment = Comment.new
  end
                   
  # Stores the username into a variable that will be used throughout the program to log in, access user id, and delete account.
  def username
    puts "What is your username?"
    @username = gets.chomp.downcase
  end

  # Stores password into a variable that will be used to log in, delete account, or access user id.
  def password
    puts "What is your password?"
    @password = gets.chomp.downcase
  end

    #Prior to the program menu, the user has to verify that he/she has an account in the database. This function verifies that it exists, if not, it kicks the user out.
  def logIN()
    logINattempt = 0
    puts "\n\tYou will be temporary kicked off if your password or username is incorrect three times.\n "
    while logINattempt < 3 do
      if @user.accountID(username, password)
        puts "\nGlad to have you return, #{@username}. "
        logINattempt = 3
        return true
      else
        puts "Username or password is wrong."
        logINattempt += 1
      end
    end
  end

  #An account is created sing the values stored in username and password.
  def createUser
    @user.insert(username, password)
    puts "\nThank you for joining us, #{@username}.\n "
  end

  def addCommentOrSeeComment()
    puts "\nWould you like to comment on a post or see the comments? Type 'comment' or 'see'"
    @content = gets.chomp.downcase
    if @content == "comment"
      @comment.insertComment(@post.postID(titleComment()), comment)
    elsif @content == "see"
      #enter function that displays comments
    else
      puts "Type either 'comment' or 'see.'"
      addComment()
    end
  end

  def titleComment()
    puts "What post would you like to comment on? Type the title."
    @title = gets.chomp
  end
  
   def comment()
    puts "What would you like to comment?"
    @content = gets.chomp
  end

  def intro()
    puts "\tWelcome to the forumn. Would you like to log in or create an account? Keywords are 'log in' or 'create'.\n"
    @answer = gets.chomp.downcase
    if @answer == "log in"
      if logIN()
        options()
      end
    elsif @answer == "create"
      createUser()
      options()
    else
      puts "Type either 'log in' or 'create'\n"
      intro()
    end
  end
  
  def options()
    puts "\n\tWelcome to the DL forum. Here you can create posts, and delete your account or posts. There are a few keywords you will have to keep in mind though: 'create post', 'delete user', 'delete post', 'show post', 'log out', or 'comment.' Keep in mind that if you submit a word that is not a keyword you will be met with an error, asking for one of the keywords. Enjoy and have fun.\n"
    keyword = gets.chomp.downcase
    if keyword == "create post"
      @post.createPost(@user.accountID(@username, @password))
    elsif keyword == "delete user"
      @user.delAccount(@username, @password)
    elsif keyword == "delete post"
      @post.delPost(@user.accountID(@username, @password))
    elsif keyword == "show post"
      @post.showPost()
      addCommentOrSeeComment()
    elsif keyword == "log out"
      abort("Exiting the DL forum. Thank you for coming")
    else
      puts "\nType in one of the keywords: 'create post', 'show post', 'delete user', 'delete post', or 'log out\n'"
    end
    options()
  end
end
