#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t -c"

# generate actual number
ACTUAL_NUM=$(( RANDOM % 1000 + 1 ))
# set number guesses
NUMBER_OF_GUESSES=0

MAIN_FN(){
  # print asking username
  echo "Enter your username:"
  read USERNAME

  # get player id in db
  PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE username = '$USERNAME'");

  # check username in db
  if [[ -z $PLAYER_ID ]]
  then
    # print welcome msg for 1st time player
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    # insert new data in db
    INSERT_PLAYER=$($PSQL "INSERT INTO players(username) VALUES('$USERNAME')")
    # get player id in db
    PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE username = '$USERNAME'");
  else
    USERNAME_DB=$($PSQL "SELECT username FROM players WHERE player_id = $PLAYER_ID" | sed 's/ //g' );
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM players WHERE player_id = $PLAYER_ID" | sed 's/ //g' );
    BEST_GAME=$($PSQL "SELECT best_game FROM players WHERE player_id = $PLAYER_ID" | sed 's/ //g' );
    
    echo "Welcome back, $USERNAME_DB! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi

  # run main function
  GAME_FUNCTION
}

GAME_FUNCTION(){
  
  # get guess number from input
  if [[ $1 ]]
  then
    echo "$1"
  else
    echo "Guess the secret number between 1 and 1000:"
  fi
  read GUESS_NUM
  
  # check if input is not number
  if [[ ! $GUESS_NUM =~ ^[0-9]+$ ]]
  then
    GAME_FUNCTION "That is not an integer, guess again:"
  else    
    NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))

    # the input is number, check if the numbers is same
    if [[ $ACTUAL_NUM = $GUESS_NUM ]]
    then
      # print message
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $GUESS_NUM. Nice job!"

      # add best_game if it is not 0 and few than prev best_game
      PREV_BEST_GAME=$($PSQL "SELECT best_game FROM players WHERE player_id = $PLAYER_ID")

      if [[ $PREV_BEST_GAME -eq 0 || $NUMBER_OF_GUESSES -lt $PREV_BEST_GAME ]]
      then
        UPDATE_GAMES_PLAYED=$($PSQL "UPDATE players SET games_played = games_played + $NUMBER_OF_GUESSES WHERE player_id = $PLAYER_ID")
        UPDATE_BEST_GAME=$($PSQL "UPDATE players SET best_game = $NUMBER_OF_GUESSES WHERE player_id = $PLAYER_ID")
      fi
    else
      # check if lower or higher
      if [[ $GUESS_NUM -gt $ACTUAL_NUM ]]
      then
        GAME_FUNCTION "It's lower than that, guess again:"
      elif [[ $GUESS_NUM -lt $ACTUAL_NUM ]]
      then
        GAME_FUNCTION "It's higher than that, guess again:"
      fi
    fi
  fi
}

MAIN_FN