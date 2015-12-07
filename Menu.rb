require 'highline/import'

require_relative './User'
require_relative './Post'
require_relative './Comment'

class Menu

  def initialize(db)
    @db = db
    @user = User.new(@db)
    @post = Post.new(@db)
  end

  def usernamePassword
    @username = ask("Username? ") { |u| u.validate = /\A\w+\Z/ }
    @password = ask("Password? ") { |p| p.validate = /\A\w+\Z/ }
  end

  def newLogIN
    attempts = 0
    while attempts <= 3
      say "\n\tYou will be kicked off if your password or username is incorrect three times. Number of attempts #{attempts}.\n "
      usernamePassword()
      if @user.accountID(@username, @password)
        say("\nGlad to have you return, #{@username}.\n")
        newOptions
      else
        attempts += 1
      end
    end
  end

  def createUser()
    usernamePassword()
    @user.insert(@username, @password)

    puts "\nThank you for joining us, #{@username}.\n "
    newOptions
  end

  def later
    puts "Later"
    exit 0
  end

  def newIntro
    @cli.choose do |menu|
      menu.prompt = "\tWelcome to the forumn. Would you like to log in or create an account? Keywords are 'log in' or 'create' or 'exit'.\n"
      menu.choice("log in") { newLogIN }
      menu.choice("create") { createUser }
      menu.choice("exit") { later }
    end
  end
  
  def loggingOut
    say("logging out")
    newIntro
  end

  def newOptions
    @cli.choose do |menu|
      menu.prompt = "\n\tWelcome to the DL forum. Here you can create posts, and delete your account or posts. There are a few keywords you will have to keep in mind though: 'create post', 'delete user', 'delete post', 'show post', 'log out', or 'comment.' Keep in mind that if you submit a word that is not a keyword you will be met with an error, asking for one of the keywords. Enjoy and have fun.\n\n"
      menu.choice("create post") { @post.createPost(@user.accountID(@username, @password)) }
      menu.choice("delete user") { @comment.delUsrComment(@user.accountID(@username, @password))
@post.delUsrPost(@user.accountID(@username, @password))
@user.delAccount(@username, @password) }
      menu.choice("delete post") { @post.delPost(@user.accountID(@username, @password)) }
      menu.choice("show post") { @post.newShowPost(@user.accountID(@username, @password)) }
      menu.choice("logout") { loggingOut}
    end
    newOptions
  end
end
