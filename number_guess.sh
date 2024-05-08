#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# print asking username
echo "Enter your username:"
read USERNAME

# get username in db
USERNAME_DB=$($PSQL "SELECT * FROM players WHERE username = '$USERNAME'");

# check username in db
if [[ -z $USERNAME_DB ]]
then
  # insert new data in db
  # print welcome msg for 1st time player
  # run main function
else
  # print welcome msg
  # build formatted data
  # print prev game played info
  # run main function
fi