#!/bin/bash

check=true
filename=`basename "$0"`
today=`date +%Y-%m-%d.%H:%M:%S`
replacemsg=false

exec 2> >(tee "Error_.$filename._.$today.err")
exec > >(tee "Log_.$filename._.$today.log")



if [ ! -d ~/pullstack/autostack/linecounterfiles/ ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
   mkdir ~/pullstack/autostack/linecounterfiles/
   sudo chmod 775 /opt/lampp/htdocs
   cd ~/pullstack/autostack/linecounterfiles/
  
   touch controller.properties
   sudo chmod 765 controller.properties
   touch compute.properties
   sudo chmod 765 compute.properties
   touch network.properties
   sudo chmod 765 network.properties

   echo controllerone=1 >> controller.properties
   echo controllertwo=1 >> controller.properties
   echo controllerthree=1 >> controller.properties
   echo controllerfour=1 >> controller.properties
   
   echo computeone=1 >> compute.properties
   echo computetwo=1 >> compute.properties
   echo computethree=1 >> compute.properties
   echo computefour=1 >> compute.properties
   
   echo networkone=1 >> network.properties
   echo networktwo=1 >> network.properties
   echo networkthree=1 >> network.properties
   echo networkfour=1 >> network.properties
  
else
 
   if [ ! -f ~/pullstack/autostack/linecounterfiles/controller.properties ]; then
       
   cd ~/pullstack/autostack/linecounterfiles/
   touch controller.properties
   sudo chmod 765 controller.properties

   echo controllerone=1 >> controller.properties
   echo controllertwo=1 >> controller.properties
   echo controllerthree=1 >> controller.properties
   echo controllerfour=1 >> controller.properties
   
   fi

   if [ ! -f ~/pullstack/autostack/linecounterfiles/compute.properties ]; then

   cd ~/pullstack/autostack/linecounterfiles/
   touch compute.properties
   sudo chmod 765 compute.properties

   echo computeone=1 >> compute.properties
   echo computetwo=1 >> compute.properties
   echo computethree=1 >> compute.properties
   echo computefour=1 >> compute.properties
   
   fi

   if [ ! -f ~/pullstack/autostack/linecounterfiles/network.properties ]; then

   cd ~/pullstack/autostack/linecounterfiles/
   touch network.properties
   sudo chmod 765 network.properties

   echo networkone=1 >> network.properties
   echo networktwo=1 >> network.properties
   echo networkthree=1 >> network.properties
   echo networkfour=1 >> network.properties
   
   fi
   

fi


if [ ! -f ~/pullstack/autostack/autostack.properties ]; then
       
   cd ~/pullstack/autostack/
   touch controller.properties
   sudo chmod 765 controller.properties

   #echo computeone=1 >> controller.properties
   #echo controllertwo=1 >> controller.properties
   #echo controllerthree=1 >> controller.properties
   #echo controllerfour=1 >> controller.properties
   pwd
fi



hostname=$(hostname)
echo ----******--Welcome to $hostname--******----

. ~/pullstack/autostack/linecounterfiles/compute.properties
. ~/pullstack/autostack/autostack.properties

if [ "$computeone" -eq 9 ]; then

echo -----------------------------------------------------
echo \|   This Shell Script has been Executed Successfully. \|
echo -----------------------------------------------------

echo If you Want to execute it again Press [y/n] to Execute it.
read userchoice
     if [ "$userchoice" = "y" ]; then
     echo Enter Line Number you want to continue: [Valid 1 - 10] 
     echo And Execute it again.
     read againlinenumber

    sed "s/computeone=.*/computeone=$againlinenumber/g" ~/pullstack/autostack/linecounterfiles/compute.properties > tmp
    mv tmp ~/pullstack/autostack/linecounterfiles/compute.properties 
fi

exit
else

echo Starting $filename
fi


# Define your function here
line_counter_increment () {
   sed "s/computeone=.*/computeone=$count/g" ~/pullstack/autostack/linecounterfiles/compute.properties > tmp
   mv tmp ~/pullstack/autostack/linecounterfiles/compute.properties
   return "$computeone"
}




echo COMPUTE_NODE_HOSTNAME = $COMPUTE_NODE_HOSTNAME
echo COMPUTE_NODE_PUBLIC_IP = $COMPUTE_NODE_PUBLIC_IP
echo COMPUTE_NODE_PRIVATE_IP = $COMPUTE_NODE_PRIVATE_IP


echo ======= Counter Value is "$computeone" =============

echo ---- If above information is correct then- Press y to continue- or n to exit------
echo ---- otherwise add configurations in- ~/pullstack/autostack/autostack.properties -----

echo --- Press[y/n] to continue- or to skip------

read choice
if [ "$choice" = "y" ] && [ "$check" = true ]; then

#---------------------- Create User [ START ] ---------------------------------------------
user=$(cut -d: -f1 /etc/passwd | grep autostack)

if [ -z "$user" ]
then
sudo useradd -m -p autostack autostack
echo -e 'autostack\nautostack\n' | sudo passwd autostack || usercreate=false
if [ -s ~/pullstack/autostack/conf/common/autostack ]; then
        sudo cp ~/pullstack/autostack/conf/common/autostack /etc/sudoers.d/     
        fi
if [ "$usercreate" = true ]; then
echo ----------------------------------------
echo \|   Created a new super-user : autostack \|
echo \|   Password of autostack  : autostack . \|
echo ----------------------------------------
source=~/pullstack
destination=/home/autostack/

if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
fi
sudo cp -R "$source" "$destination"
fi
fi
fi
#---------------------- Create User [ ENDS ] ---------------------------------------------


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



if [ "$check" = true ] && [ "$computeone" -eq 1 ]; then
pwd || check=false
echo -------------------$filename line no : "$computeone"------------------------
#line no 1
((computeone=computeone+1))
fi


if [ "$check" = true ] && [ "$computeone" -eq 2 ]; then

sudo apt-get update || check=false
echo -------------------$filename line no : "$computeone"------------------------
#line no 2
((computeone=computeone+1))
fi

if [ "$check" = true ] && [ "$computeone" -eq 3 ]; then

echo -------- installing openssh server ----------
sudo apt-get install openssh-server -y || check=false
echo -------- installing ssh-pass -----------
sudo apt-get install sshpass -y || check=false
echo -------------------$filename line no : "$computeone"------------------------
#line no 3
((computeone=computeone+1))
fi

if [ "$check" = true ] && [ "$computeone" -eq 4 ]; then
sudo apt-get install ubuntu-cloud-keyring || check=false

echo -------------------$filename line no : "$computeone"------------------------
#line no 4
((computeone=computeone+1))
fi

if [ "$check" = true ] && [ "$computeone" -eq 5 ]; then
sudo echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
  "trusty-updates/juno main" > /etc/apt/sources.list.d/cloudarchive-juno.list || check=false


echo -------------------$filename line no : "$computeone"------------------------
#line no 5
((computeone=computeone+1))
fi

if [ "$check" = true ] && [ "$computeone" -eq 6 ]; then
sudo apt-get update && sudo apt-get update --fix-missing && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y || check=false
sudo apt-get install mariadb-server python-mysqldb -y || check=false
echo -------------------$filename line no : "$computeone"------------------------
#line no 6
((computeone=computeone+1))
fi

if [ "$check" = true ] && [ "$computeone" -eq 7 ]; then
sudo chmod 755 replace.sh
( exec "./replace.sh" ) || check=false
replacemsg=true
echo -------------------$filename line no : "$computeone"------------------------
#line no 7
((computeone=computeone+1))
fi

if [ "$check" = true ] && [ "$computeone" -eq 8 ]; then

sudo chmod 755 ~/pullstack/autostack/scripts/compute/computefirst.sh || echo "Unable to set Permission"
sudo chmod 755 ~/pullstack/autostack/scripts/compute/computentp.sh || echo "Unable to set Permission"
sudo chmod 755 ~/pullstack/autostack/scripts/compute/computenetwork.sh || echo "Unable to set Permission"
sudo chmod 755 ~/pullstack/autostack/scripts/compute/computenova.sh || echo "Unable to set Permission"
sudo chmod 755 ~/pullstack/autostack/scripts/compute/replace.sh || echo "Unable to set Permission"

echo -------------------$filename line no : "$computeone"------------------------
#line no 8
((computeone=computeone+1))

sed "s/computeone=.*/computeone=$computeone/g" ~/pullstack/autostack/linecounterfiles/compute.properties > tmp
   mv tmp ~/pullstack/autostack/linecounterfiles/compute.properties

if [ "$replacemsg" = true ]; then
echo   ---------------------------------------------------------------------------------------------------------------------------------------------
echo \|  [ NOTE : Verify Your configuration at ~/pullstack/autostack/conf/check_autostack_configuration.txt and then- only move to next Step ] \|
echo   ---------------------------------------------------------------------------------------------------------------------------------------------
fi



exit

fi


   ((computeone=computeone-1))
   sed "s/computeone=.*/computeone=$computeone/g" ~/pullstack/autostack/linecounterfiles/compute.properties > tmp
   mv tmp ~/pullstack/autostack/linecounterfiles/compute.properties


if [ "$replacemsg" = true ]; then
echo   ---------------------------------------------------------------------------------------------------------------------------------------------
echo \|  [ NOTE : Verify Your configuration at ~/pullstack/autostack/conf/check_autostack_configuration.txt and then- only move to next Step ] \|
echo   ---------------------------------------------------------------------------------------------------------------------------------------------
fi



fi

exit