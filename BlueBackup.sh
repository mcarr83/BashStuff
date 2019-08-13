#!/bin/bash

#Program: Blue Backup (server) and ZIP
#Author: Michael Carr
#Version: Dos

#Variables to be used
DATE=$(date +%F)
USER=$(whoami)

#Notes
echo -e "\e[1;31m **Blue Backup and ZIP Program** \e[0m"
echo ""
echo -e "\e[1;31m Some files will NOT be moved due to permissions or due to \e[0m"
echo -e "\e[1;31m being hidden. Please change permissions if you want them moved. \e[0m"
echo -e "\e[1;31m chmod 755 (file or directory name) for permissions \e[0m"
echo -e "\e[1;31m Also note: large files and directories will take time. \e[0m"
echo -e "\e[0;37m \e[0m"

sleep 10

#Make new directory
echo "Making temp folder BackupTemp"
echo ""
mkdir BackupTemp

FILES=$(ls)

#Runs through every file or directory and copies it to a the new folder
function CopyFiles() {
    for FILE in $FILES
    do

	if [ -d $FILE ] #Directory check
	then
	    #Don't include BackupTemp for obvious reasons
	    if [ $FILE != BackupTemp ]
	    then
		echo "Copying directory ${FILE}"
		cp ${FILE} -r BackupTemp
	    fi

	else
	    if [ $FILE != *.zip ]
	    then
	       echo "Copying file ${FILE}"
	    cp ${FILE} BackupTemp

	    fi
	fi
    done

}

#*** Zip Folder function ***
function ZipFolder() {
    echo ""
    echo -e "\e[1;31m Zipping temp folder $USER-$DATE-BackupTemp \e[0m"
    echo ""
    zip -r $USER-$DATE-Backup.zip BackupTemp

    if [ $? -eq 0 ] #if it doesn't work exit with code
    then
	echo ""
	echo -e "\e[1;31m Zip completed \e[0m"
	echo ""

    else
	echo -e "\e[1;31m Error while zipping folder \e[0m"
	echo -e "\e[1;31m Error code: 2 \e[0m"
	exit 2

    fi

}

#*** Remove temp folder function ***#
function RemoveTemp() {
    echo -e "\e[1;31m Removing temp folder BackupTemp \e[0m"

    if [ -d BackupTemp ] #if there is no folder called BackupTemp do not do anything and exit with a code
    then

	rm -r -f BackupTemp #-r is recursive and -f is used to suppress warnings
	echo -e "\e[1;31m Remove completed \e[0m"

    else
	echo -e "\e[1;31m Error while removing folder \e[0m"
	echo -e "\e[1;31m Error code: 3 \e[0m"
	exit 3
    fi
}

#*** Message Function ***#
function Done() {
    #Done message
    echo ""
    echo -e "\e[1;31m Doneskis!!! Backup succeeded. \e[0m" #Nod to one of my favorite Youtubers
    echo -e "\e[1;31m Go to FileZile and download $USER-$DATE-Backup.zip \e[0m"
    echo -e "\e[0;37m \e[0m"
    }

#Copy files function call
CopyFiles

#Zip folder function call
ZipFolder

#Remove Temp folder function call
RemoveTemp

#Done message function call
Done


exit 0
