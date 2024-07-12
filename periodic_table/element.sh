# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide an element as an argument."
    exit 
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

# Function to fetch element information based on atomic number, symbol, or name
get_element_info() {
if [[ $1 =~ ^[0-9]+$ ]]; then
  # Wenn $1 eine Zahl ist, führe die Abfrage mit der atomic_number durch
  element=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = $1")
else
  # Wenn $1 keine Zahl ist, führe die Abfrage mit name oder symbol durch
  element=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name = '$1' or symbol = '$1'")
fi

if [[ -z "$element" ]]; then
  echo "I could not find that element in the database."
else
echo $element | while IFS=" |" read an name symbol type mass mp bp 
do
  echo -e "The element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
done
fi
}

# Handle arguments
if [ $# -eq 1 ]; then
    # Call function to get element information based on the argument
    get_element_info "$1"
else
    echo "I could not find that element in the database."
    exit 1
fi