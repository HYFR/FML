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
        foreign_key :user_id, :forum
        String :content
      end
    end
    @currentComment = DB[:comments]
  end

  #Used in adCommentOrSeeComment function in Menu.rb
  def insertComment(post, comment)
    @currentComment.insert(:user_id => post, :content => comment)
  end

  def delUsrComment(id)
    @currentComment.where(:user_id => id).delete()
  end
end
