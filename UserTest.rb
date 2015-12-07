require 'minitest/autorun'
require_relative 'methods.rb'

class Testing < MiniTest::Unit::TestCase
  def setup
    #relative memory database
    @db = Sequel.sqlite
    @user = User.new(@db)
  end

  def test_insert
    assert_equal 1, @user.insert("japhet", "perez")
    assert_equal 2, @user.insert("1234", "asdf")
    assert_equal 3, @user.insert("", "")
    assert_equal 4, @user.insert("#@!@#", "1234dsaf#")
    assert_equal 5, @user.insert("japhet", "perez")
  end

  def test_accountID
    #db input
    @user.insert("japhet", "perez")
    @user.insert("1234", "asdf")

    #testing methods for db input
    assert_equal 1, @user.accountID("japhet", "perez")
    assert_equal 2, @user.accountID("1234", "asdf")
    assert_equal nil, @user.accountID("123", "sdf")
  end

  def test_delete
    #db input
    @user.insert("japhet", "perez")
    @user.insert("1234", "adf")

    #testing method
    assert_equal 1, @user.delete("japhet", "perez")
    assert_equal 1, @user.delete("1234", "adf")
    assert_equal 0, @user.delete("asdfsadfsa", "sdfasfdasd")
  end                       

  def teardown
    @db[:user].delete
  end
end
