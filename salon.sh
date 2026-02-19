#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n" 
EXIT() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
}

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
 
 read SERVICE_ID_SELECTED

 # case $SERVICE_ID_SELECTED in
  #  1) ;;
   # 2) ;;
   # 3) ;;
   # 4) ;;
   # 5) ;;
   # *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  #esac
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    # if input is not a number
    if [[ ! "$SERVICE_ID_SELECTED" =~ ^[1-5]$ ]]
    then
      # send to main menu
      MAIN_MENU "I could not find that service. What would you like today?"
    else
        # get customer info
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        # if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME

          # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
        fi
        
        # get customer_id
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
        
        # get APPOINTMENT TIME
          echo -e "\nWhat time would you like your$SERVICE_NAME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
          read SERVICE_TIME
        
        # insert APPOINTMENT TIME
        INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

        # send to main menu
        EXIT "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
        
      fi
}
MAIN_MENU
