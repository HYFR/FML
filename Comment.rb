class Comment

  def initialize(db)
    @db = db
    commentTable()
  end
  
  def commentTable
    exist = @db.table_exists?(:comments)
    if exist == true
    else
      @db.create_table :comments do
        primary_key :commentNumber
        foreign_key :user_id, :user
        foreign_key :post_id, :forum
        String :title
        String :content
      end
    end
    @currentComment = @db[:comments]
  end

  #Used in adCommentOrSeeComment function in Menu.rb
  def insertComment(post, user, title, comment)
    @currentComment.insert(:post_id => post, :user_id => user, :title => title, :content => comment)
  end

  def delUsrComment(id)
    @currentComment.where(:user_id => id).delete()
  end

  def showComment(id)
    @currentComment.where(:post_id => id).to_hash(:commentNumber, :content)
  end
end
