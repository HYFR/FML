require 'test/unit'
require_relative 'methods.rb'

class TestDB < Test::Unit::TestCase
  def test_db
    # create instances of User and Post class
    currentUser = User.new()
    currentPost = Post.new()

    # intialized variables for User class unit tests
    database = currentUser.verifyDB
    verify = currentUser.verifyAccount
    tryAgain = currentUser.tryAgain
    create = currentUser.createUser
    delete = currentUser.delAccount

    # unit tests for User class
    assert_equal(true, exist = DB.table_exists?(:user))
    assert_equal(@@userAccount = DB[:user], database)
    assert_equal(true, verify)
    assert_equal(true, tryAgain)
    assert_equal(true, create)
    assert_equal(true, delete)
    
    # intialized variables for Post class unit tests
    check = currentPost.checkPostTable
    create = currentPost.createPost(verify)
    delete = currentPost.delPost

    # unit tests for Post class
    assert_equal(true, forum = DB.table_exists?(:forum))
    assert_equal(@@currentPost = DB[:forum], check)
    assert_equal(true, create)
    assert_equal(true, delete)
    # The last unit test only passes after the method is called on the instance of Post. The delete method deletes the posts in the Forum class, bringing the number of posts to 0.
    assert_equal(0, @@currentPost.delete())
  end
end
