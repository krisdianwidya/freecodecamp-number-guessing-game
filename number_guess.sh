#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

# print asking username
echo "Enter your username:"
read USERNAME