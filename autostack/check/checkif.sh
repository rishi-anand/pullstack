#!/bin/bash
#trap 'echo "# $BASH_COMMAND"' DEBUG
#set -x
#set -o verbose
#mkdir ~/autostack/check/log
# Logs stderr and stdout to separate files.

#today=$(date +%Y-%m-%d)

today=`date +%Y-%m-%d.%H:%M:%S`

#mylog=somefile.err
#timestamp=$(date +%Y%m%d%H%M%S)
#echo "\nStarting regular backup at $timestamp" >> somefile.err
#tar -zvcf backup.web.$timestamp.tar.gz /var/www 2>&1 >> $mylog
#chown digity:marines *.gz 2>>$mylog
#chmod 660 *.gz 2>>$mylog
#exec > >(tee "somefile.$today.log")

#. ~/open/autostack.properties

#exec 2> >(tee "somefile.$today.err")
#exec > >(tee "somefile.$today.log")

count=100
linenumber=0
check=true
filename=`basename "$0"`
#echo $KEYSTONE_DBPASS


#Calling one shell script from another script
( exec "./test.sh" )
echo --- Press[y/n] to continue- or n to skip------
#read next
if [ "$next" = "y" ]; then
if [ "$check" = true ] && [ $count -eq 100 ] ; then
((linenumber=linenumber+1))
if [ -s ~/autostack/check/checkif.sh ]; then
sudo mkdir /rishiislive || check=false
fi
cd || check=false
#apt-get update || check=false
echo -------------------$filename line no : $linenumber------------------------
fi
#while true; do sleep 0.25 && echo -ne "\rActivity: \\" && sleep 0.25 && echo -ne "\rActivity: |" && sleep 0.25 && echo -ne "\rActivity: /" && sleep 0.25 && echo -ne "\rActivity: -"; done;

########################################################3


###########################################################

if [ "$check" = true ] ; then
((linenumber=linenumber+1))
cd  || check=false 
echo -------------------$filename line no : $linenumber------------------------
fi
fi


