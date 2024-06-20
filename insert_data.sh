#! /bin/bash
clear

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams,games")

function insert_teams ()
{
 if [[ $1 != $2 ]]
    then
      # Try to get team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1'")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$1')")
      if [[ $INSERT_TEAM_ID_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games, $2, $1
      fi
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1'")
  #    echo -e "\n" TEAM_ID in function is: $TEAM_ID "\n"
    fi
  fi
  #echo $TEAM_ID
}

cat games.csv |  while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS


#Get unique list of team names
do
  insert_teams "$WINNER" "winner"
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  # echo -e "\nwinner_id is $WINNER_ID"
  insert_teams "$OPPONENT" "opponent"
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
 #	echo -e "\nopponent_id is $OPPONENT_ID"
   if [[ $YEAR != "year" ]]
   then
    INSERT_GAME_ID_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done
echo "Number of teams: " $($PSQL "SELECT COUNT(*) FROM teams");

echo "Number of games: " $($PSQL "SELECT COUNT(*) FROM games");
