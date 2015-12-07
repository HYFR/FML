#include  array.c

class Post
  def initialize(db)
    @db = db
    checkPostTable()
    @comment = Comment.new(@db)
  end
  
  def checkPostTable
    forumn = @db.table_exists?(:forum)
    if forumn == true
    else
      @db.create_table :forum do
        primary_key :post_id
        foreign_key :user_id, :user
        String :title
        String :content
        String :category
      end
    end
    #create a instance variable of the dataset 'forum'
    @currentPost = @db[:forum]
  end

  def insertContent(id)
    @currentPost.insert(:user_id => id, :title => @title, :content => @content, :category => @category)
  end

  #Creates the title for createPost(id) function
  def title
    puts "What would you like the title of your post to be? "
    @title = gets.chomp
  end

  def actualTitle(title)
    @actualTitle = title
  end

  #Creates content for createPost(id) function, used in createPost function
  def content
    puts "What would you like the content of your post to be? "
    @content = gets.chomp
  end

  def actualContent(content)
    @actualContent = content
  end

  #Used in Menu.rb's function addCommentOrSeeComment
  def postID(title)
    @postID = @currentPost.where(:title => title).get(:post_id)
  end
  
  #Used in Menu.rb's function addCommentOrSeeComment
  def postTitle(title)
    @postTitle = @currentPost.where(:title => title)
  end

  def newCategory
    choose do |menu| 
      menu.prompt = "In what category would you like your post to be in?"
      menu.choice("love") { @category = "love" }
      menu.choice("money") { @category = "money" }
      menu.choice("work") { @category = "work" }
      menu.choice("health") { @category = "health" }
      menu.choice("funny") { @category = "funny" }
    end
  end

  def actualCategory(category)
    @actualCategory = category
  end

  #Creates post, used in options function in Menu.rb
  def createPost(id)
    #Fill the forumn table with a title and content
    title()
    content()
    newCategory()
    insertContent(id)
    puts "\nYour post, titled '#{@title}' was successfully created.\n "
  end
  
  #Used to delete title from existing post. Used in delPost function
  def delTitle
    @currentPost.where(:title => @title).delete()
  end

  def delUsrPost(id)
    @currentPost.where(:user_id => id).delete()
  end

  #Called from options function in Menu.rb
  def delPost(id)
    puts "#{@currentPost.where(:user_id => id).to_hash(:title, :content)}"
    puts "Your account's posts have been displayed. Type the Title of the post you want to delete."
    @title = gets.chomp
    @comment.delUsrComment(id)
    delTitle()
    puts "\nThe post titled  '#{@title}' has been deleted.\n "
  end

  #Required to show the posts in showPost() function.
  def post
    @currentPost.to_hash(:title, :content)
  end

  #Displays posts in a specific category. 
  def categoryPost(category)
    @currentPost.where(:category => category).to_hash(:title, :content)
  end

  def showPostStatement(category)
    puts "\nThese are all the posts categorized as '#{category}'\n"
  end

  def output(category)
    @inputArray =  "#{@currentPost.to_hash(:title, :content)}"
  end

  def splitArray(input)
    stuff = input.split('=>').sort_by(&:length).pop
    print "Title: #{stuff}"
  end
      
  def newShowPost(id)
    choose do |menu|
      menu.prompt = "\nWhat category of posts would you like to see?\n"
      menu.choice("all") { @category = "all" }
      menu.choice("love") { @category = "love" }
      menu.choice("money") { @category = "money" }
      menu.choice("work") { @category = "work"}
      menu.choice("health") { @cateogry = "health" }
      menu.choice("funny") { @category = "funny" }
    end
    splitArray(output(@category))
  end
  
  def showPost(id)
    puts "\nWhat category of posts would you like to see? Love, Money, Work, Misc., Health, or All?\n"
    @category = gets.chomp.downcase
    if @category ==  "all"
      posts = post()
      showPostStatement(@category)
      puts "#{posts}"
    elsif @category == "love"
      love = categoryPost(@category)
      showPostStatement(@category)
      puts "#{love}"
    elsif @category == "money"
      money = categoryPost(@category)
      showPostStatement(@category)
      puts "#{money}"
    elsif @category == "work"
      work = categoryPost(@category)
      showPostStatement(@category)
      puts "#{work}"
    elsif @category == "misc"
      misc = categoryPost(@category)
      showPostStatement(@category)
      puts "#{misc}"
    elsif @category == "health"
      health = categoryPost(@category)
      showPostStatement(@category)
      puts "#{health}"
    else
      puts "Type one of the categories: Love, Money, Work, Misc., Health, or All"
      showPost()
    end
    addCommentOrSeeComment(id)
  end

  def addCommentOrSeeComment(id)
    puts "\nWould you like to comment on a post or see the comments? Type 'comment' or 'see'\n"
    @content = gets.chomp.downcase
    if @content == "comment"
      titleComment()
      @comment.insertComment(postID(@commentTitle), id , @commentTitle, comment)
    elsif @content == "see"
      choosePost()
      displayComment = @comment.showComment(postID(@choice))
      puts "#{displayComment}"
    else
      
      puts "Type either 'comment' or 'see comments.'"
      addCommentOrSeeComment(id)
    end
  end

  def choosePost
    puts "What post would you like to see? Type the title"
    @choice = gets.chomp
  end

  def titleComment()
    puts "What post would you like to comment on? Type the title."
    @commentTitle = gets.chomp
  end
  
   def comment()
    puts "What would you like to comment?"
    @content = gets.chomp
   end
end
