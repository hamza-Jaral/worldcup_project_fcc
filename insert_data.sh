#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate teams, games")
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    #check winner and opponent id
    winner_id=$($PSQL "select team_id from teams where name='$winner'")
    if [[ -z $winner_id ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$winner')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $winner
        winner_id=$($PSQL "select team_id from teams where name='$winner'")
        echo winner_id: $winner_id
      fi
    fi
    opp_id=$($PSQL "select team_id from teams where name='$opponent'")
    if [[ -z $opp_id ]]
    then
      # insert opponent
      INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      if [[ $INSERT_OPP_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $opponent
        opp_id=$($PSQL "select team_id from teams where name='$opponent'")
        echo opponent_id : $opp_id
      fi
    fi
    #insert data into match table
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES('$year', '$winner_id', '$opp_id', '$winner_goals', '$opponent_goals', '$round')")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]               
    then
      echo Inserted into games, $year $round
    fi   
  fi
done