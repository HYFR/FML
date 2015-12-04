class User

  def initialize(db)
    @db = db
    verifyDB()
  end
  
  #Checks to see if a 'user' table exists in the FML database
  def verifyDB
    exist = @db.table_exists?(:user)
    if exist == true
    else
      #Create a user table in the database
      @db.create_table :user do
        primary_key :user_id
        String :name
        String :password
      end
    end
    # Creates a class variable dataset of the 'user' table.
    @userDataset = @db[:user]
  end

  #Used in the options function in Menu.rb
  def accountID(username, password)
    @accountID = @userDataset.where(:name => username).where(:password => password).get(:user_id)
  end

  #Saves username/password in db
  def insert(username, password)
    @userDataset.insert(:name => username, :password => password)
  end

  #required in delAccount(username, password) 
  def delete(username, password)
    @userDataset.where(:name => username).where(:password => password).delete()
  end
  
  def delAccount(username, password)
    delete(username, password)
    puts "Your account, '#{username}', was successfully deleted"
    puts "We are sorry to see you go."
    exit
  end
end
