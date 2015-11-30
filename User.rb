class User
  def initialize
    verifyDB()
  end
  
  #Checks to see if a 'user' table exists in the FML database
  def verifyDB
    exist = DB.table_exists?(:user)
    if exist == true
    else #Create a user table in the database
      DB.create_table :user do
        primary_key :user_id
        String :name
        String :password
      end
    end
    @userDataset = DB[:user] # Creates a class variable dataset of the 'user' table.
  end

  #Used in the options function in Menu.rb
  def accountID(username, password)
    @accountID = @userDataset.where(:name => username).where(:password => password).get(:user_id)
  end

  #Saves username/password in db
  def insert(username, password)
    @userDataset.insert(:name => username, :password => password)
  end

  #An important function for delAccount() to work. 
  def delete(username, password)
    @userDataset.where(:name => username).where(:password => password).delete()
  end
  
  #We see the use of username and password come into use here. The values identify which account is deleted.
  def delAccount(username, password)
    delete(username, password)
    puts "Your account, '#{username}', was successfully deleted"
    abort("We are sorry to see you go.")
  end
end
