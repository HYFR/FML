class Comment < Post
  def initialize
    commentTable()
  end
  
  def commentTable
    exist = DB.table_exists?(:comments)
    if exist == true
    else
      DB.create_table :comments do
        primary_key :commentNumber
        foreign_key :post_id, :forum
        String :content
      end
    end
    @currentComment = DB[:comments]
  end

  #Used in adCommentOrSeeComment function in Menu.rb
  def insertComment(post, comment)
    @currentComment.insert(:post_id => post, :content => comment)
  end
end
