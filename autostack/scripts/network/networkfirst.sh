#!/bin/bash

#. ~/pullstack/autostack/linecounterfiles/controller.properties

~/pullstack/autostack/autostack.properties

check=true
filename=`basename "$0"`
today=`date +%Y-%m-%d.%H:%M:%S`
controllerfirst=1

exec 2> >(tee "Error_.$filename._.$today.err")
exec > >(tee "Log_.$filename._.$today.log")





#-------------------- Check if Internet is working if not working then updating Nameserver [STARTS]-----------------------------------
internet_working=true
is_resolv=true
ping -c 3 www.google.com || internet_working=false
if [ "$internet_working" = false ] ; then
    
    name_server=$(cat /etc/resolv.conf | grep $NAMESERVER_IP )
        if [ -z "$name_server" ]
        then
             sudo echo nameserver $NAMESERVER_IP >> /etc/resolv.conf || is_resolv=false
             if [ "$is_resolv" = false ] ; then
                      if [ -s ~/pullstack/autostack/conf/common/resolv.conf ]; then
                              
                               sudo replace "NAMESERVER_IP" $NAMESERVER_IP -- ~/pullstack/autostack/conf/common/*
                               updatednameserverip=$(cat ~/pullstack/autostack/conf/common/resolv.conf | grep $NAMESERVER_IP)
                               if [ ! -z "$updatednameserverip" ]; then
                               sudo rm -rf /etc/resolv.conf
                               sudo cp ~/pullstack/autostack/conf/common/resolv.conf /etc/
                                                      else
                                                      echo ---------------------------------------------------------
                                                      echo \|   Manually Add Nameserver IP in- /etc/resolv.conf file- \|
                                                      echo ---------------------------------------------------------

                               fi
                       else
                          echo ---------------------------------------------------------
                          echo \|   Manually Add Nameserver IP in- /etc/resolv.conf file- \|
                          echo ---------------------------------------------------------


                      fi

             fi

        fi
else
echo --------------------------------
echo \|   Internet is working properly \|
echo --------------------------------
fi
#-------------------- Check if Internet is working if not working then updating Nameserver [ENDS] -------------------------------------------





# Define your function here
line_counter_increment () {
   sed "s/controllerfirst=.*/controllerfirst=$count/g" ~/pullstack/autostack/linecounterfiles/controller.properties > tmp
   mv tmp ~/pullstack/autostack/linecounterfiles/controller.properties
   
   
   return $controllerfirst
}


echo ACCOUNT_USERNAME = $ACCOUNT_USERNAME
echo ACCOUNT_PASSWORD = $ACCOUNT_PASSWORD

echo CONTROLLER_NODE_HOSTNAME = $CONTROLLER_NODE_HOSTNAME
echo CONTROLLER_NODE_PUBLIC_IP = $CONTROLLER_NODE_PUBLIC_IP
echo CONTROLLER_NODE_PRIVATE_IP = $CONTROLLER_NODE_PRIVATE_IP

echo NETWORK_NODE_HOSTNAME = $NETWORK_NODE_HOSTNAME
echo NETWORK_NODE_PUBLIC_IP = $NETWORK_NODE_PUBLIC_IP
echo NETWORK_NODE_PRIVATE_IP = $NETWORK_NODE_PRIVATE_IP

echo COMPUTE_NODE_HOSTNAME = $COMPUTE_NODE_HOSTNAME
echo COMPUTE_NODE_PUBLIC_IP = $COMPUTE_NODE_PUBLIC_IP
echo COMPUTE_NODE_PRIVATE_IP = $COMPUTE_NODE_PRIVATE_IP




echo ---- If above information is correct then- Press y to continue------
echo ---- otherwise add configurations in- ~/pullstack/autostack/autostack.properties -----

echo --- Press[y/n] to continue- or to skip------

read choice
if [ "$choice" = "y" ]; then


if [ "$check" = true ] && [ $controllerfirst -eq 1 ]; then
       if [ -s ~/pullstack/autostack/conf/controller/interfaces ]; then

        echo -###################################### Check Network Configuration -######################################
       cat ~/pullstack/autostack/conf/controller/interfaces

       echo -###################################### Check Network Configuration -######################################

         echo ---  Press[y/n] to continue- or to skip -----
       read choicenetwork
                 if [ "$choicenetwork" = "y" ]; then
                 sudo rm -rf  /etc/network/interfaces || check=false
                 sudo cp ~/pullstack/autostack/conf/controller/interfaces /etc/network/ || check=false
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
