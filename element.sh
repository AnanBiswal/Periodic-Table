#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

if [[ -z "$1" ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

ELEMENT=$1

# function to output information about element
find_element(){
  # get element information
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  ELEMENT_RESULT=$($PSQL "select e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius from elements e full join properties p using (atomic_number) full join types t using (type_id) where e.atomic_number = $1")
  else
  ELEMENT_RESULT=$($PSQL "select e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius from elements e full join properties p using (atomic_number) full join types t using (type_id) where e.symbol = '$1' or e.name = '$1'")
  fi

  # if not found
  if [[ -z "$ELEMENT_RESULT" ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT_RESULT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done 
  fi
}

find_element "$ELEMENT"
