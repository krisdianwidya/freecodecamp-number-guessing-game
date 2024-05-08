#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t -c"

# print asking username
echo "Enter your username:"
read USERNAME

# get username in db
USERNAME_DB=$($PSQL "SELECT * FROM players WHERE username = '$USERNAME'");

# check username in db
if [[ -z $USERNAME_DB ]]
then
echo a
  # insert new data in db
  INSERT_PLAYER=$($PSQL "INSERT INTO players(username) VALUES('$USERNAME')")
  # print welcome msg for 1st time player
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  # run main function
else
  # build formatted data
  echo $USERNAME_DB | while read PLAYER_ID BAR NAME BAR GAME_PLAYED BAR BEST_GAME
  do
    # print prev game played info
    echo -e "\nWelcome back, $NAME! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
  done
  # run main function
fi