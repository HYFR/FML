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
    @currentPost = @db[:forum] # create a instance variable of the dataset 'forum'
  end

  #An important function in createPost, and is the separate database interaction.
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

  #Holds category for post attribute, used in createPost function
  def category
    puts "In what category would you like your post to be? Love, Money, Work, Health, Misc."
    @category = gets.chomp.downcase
    if @category == "love"
      @category
    elsif @category == "money"
      @category
    elsif @category == "work"
      @category
    elsif @category == "misc"
      @category
    elsif @category == "health"
      @category
    elsif @category ==  "funny"
    else
      puts "Category should be one of 'Love', 'Money', 'Work', 'Animals', 'Kids', or 'Health.'"
      category()
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
    category()
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
    delTitle()
    puts "\nThe post, titled  '#{@title}' has been deleted.\n "
  end

  #Required to show the posts in showPost() function.
  def post
    @currentPost.to_hash(:title, :content)
  end

  #Displays posts in a specific category. 
  def categoryPost(category)
    @currentPost.where(:category => category).to_hash(:title, :content)
  end
  
  def showPost(id)
    puts "What category of posts would you like to see? Love, Money, Work, Misc., Health, or All?\n"
    @category = gets.chomp.downcase
    if @category ==  "all"
      posts = post()
      puts "These are all the posts, regardless of category."
      puts "#{posts}"
    elsif @category == "love"
      love = categoryPost(@category)
      puts "\nThese are all the posts categorized as 'love'\n"
      puts "#{love}"
    elsif @category == "money"
      money = categoryPost(@category)
      puts "\nThese are all the posts categorized as 'money'\n"
      puts "#{money}"
    elsif @category == "work"
      work = categoryPost(@category)
      puts "\nThese are all the posts categorized as 'work'\n"
      puts "#{work}"
    elsif @category == "misc"
      misc = categoryPost(@category)
      puts "\nThese are all the posts categorized as 'misc'\n"
      puts "#{misc}"
    elsif @category == "health"
      health = categoryPost(@category)
      puts "\nThese are all the posts categorized as 'health'\n"
      puts "#{health}"
    else
      puts "Type one of the categories: Love, Money, Work, Misc., Health, or All"
      showPost()
    end
    addCommentOrSeeComment(id)
  end

  def addCommentOrSeeComment(id)
    puts "\nWould you like to comment on a post or see the comments? Type 'comment' or 'see'"
    @content = gets.chomp.downcase
    if @content == "comment"
      titleComment()
      @comment.insertComment(postID(@commentTitle), id , @commentTitle, comment)
    elsif @content == "see"
      @comment.showComment()
    else
      puts "Type either 'comment' or 'see.'"
      addCommentOrSeeComment(id)
    end
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
