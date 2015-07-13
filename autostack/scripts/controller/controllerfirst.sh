#!/bin/bash

#. ~/pullstack/autostack/linecounterfiles/controller.properties

#. autostack.properties

check=true
filename=`basename "$0"`
today=`date +%Y-%m-%d.%H:%M:%S`
controllerfirst=1

exec 2> >(tee "Error_.$filename._.$today.err")
exec > >(tee "Log_.$filename._.$today.log")



# Define your function here
line_counter_increment () {
   sed "s/controllerfirst=.*/controllerfirst=$count/g" ~/pullstack/autostack/linecounterfiles/controller.properties > tmp
   mv tmp ~/pullstack/autostack/linecounterfiles/controller.properties
   
   
   return $controllerfirst
}






echo ---- If above information is correct then- Press y to continue------
echo ---- otherwise add configurations in- ~/pullstack/autostack/autostack.properties -----

echo --- Press[y/n] to continue- or to skip------

read choice
if [ "$choice" = "y" ]; then


if [ "$check" = true ] && [ $controllerfirst -eq 1 ]; then
       if [ -s ~/pullstack/autostack/conf/controller/interfaces ]; then
       sudo rm -rf  /etc/network/interfaces || check=false
       sudo cp ~/pullstack/autostack/conf/controller/interfaces /etc/network/ || check=false
       echo -###################################### Check Network Configuration -######################################
       cat /etc/network/interfaces

       echo -###################################### Check Network Configuration -######################################
       echo ---  Press[y/n] to continue- or to skip -----
       read choicenetwork
                 if [ "$choicenetwork" = "y" ]; then
                 echo -###################################### REBOOTING CONTROLLER -######################################
                 sudo reboot
                 fi
        else 
        echo --- Network Interfaces was not found at pullstack repository, Leaving it unchanged-----
        fi
echo -------------------$filename line no : $controllerfirst------------------------
#line no 10

fi

fi

exit