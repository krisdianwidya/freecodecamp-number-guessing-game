#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t -c"

GAME_FUNCTION(){
  # generate actual number
  ACTUAL_NUM=$(( RANDOM % 1000 + 1 ))

  # get guess number from input
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo -e "\nGuess the secret number between 1 and 1000:"
  fi
  read GUESS_NUM
  
  # check between number
  if [[ ! $GUESS_NUM =~ ^[0-9]+$ ]]
  then
    GAME_FUNCTION "That is not an integer, guess again:"
  fi
}

# print asking username
echo "Enter your username:"
read USERNAME

# get username in db
USERNAME_DB=$($PSQL "SELECT * FROM players WHERE username = '$USERNAME'");

# check username in db
if [[ -z $USERNAME_DB ]]
then
  # insert new data in db
  INSERT_PLAYER=$($PSQL "INSERT INTO players(username) VALUES('$USERNAME')")
  # print welcome msg for 1st time player
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  # run main function
  GAME_FUNCTION
else
  # build formatted data
  echo $USERNAME_DB | while read PLAYER_ID BAR NAME BAR GAME_PLAYED BAR BEST_GAME
  do
    # print prev game played info
    echo -e "\nWelcome back, $NAME! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
  done
  # run main function
  GAME_FUNCTION
fi

