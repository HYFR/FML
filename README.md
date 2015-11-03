# Instructions to run the database code.

## Requirements
Must have sqlite3 and Ruby 2.1 installed.
Open up terminal.
To begin program, type
```
ruby FML.rb
```
on the command line.

This will initiate the program.

```
Do you already have an account in the user database?
```
will appear once the program is initiated.
Type in 'no'

```
What will be your username?
```
Insert username.
```
What will be your password?
```
Would you like to delete your account within the database?

Answer whatever you'd like to do. But this section demonstrates that a user may create and delete his/her account.
```
Glad to have you stay with us
Would you like to create a post?
```
This section demonstrates that a user can create a post
```
What would you like the title of your post to be?
What would you like the content of your post to be?
Would you like to delete your post?
```
And demonstrates that a user can delete his/her post once created.

The program is simple, yet allows for the creation of an account and post, as well as the ability to delete the account and post.

## sqlite3 Database
To verify that all the user input was successfully stored in the database, type
```
sqlite3 TheFML.db
```
into the terminal.

To check the users in the database, type
```
select * from user;
```
into the terminal, and the users in the database will be displayed on the terminal.
To check the posts in the database, type
```
select * from forum;
```
into the terminal, and the posts will be displayed on the terminal.

## Unit Tests
Same requirements as above.
To begin unit tests, type
```
ruby unitTests.rb
```
into the terminal.
You will be brought into text interaction with the terminal, so just play along until text stops appearing. As soon as the prompts stop the unit test results will appear on the screen. :star2: :star2: :star2: