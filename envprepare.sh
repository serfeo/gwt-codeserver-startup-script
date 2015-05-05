#!/bin/bash
path=$(pwd)

if [ -e "${path}/gwt-codeserver.jar" ]; then
    printf ">> environment already prepared\n"
else
    if ! [ -d "${path}/temp" ]; then
        mkdir ${path}/temp
        cd ${path}/temp
    fi 
    
    printf "\n>> please, wait while gwt-2.6.1.zip downloading...\n\n"
    wget "http://storage.googleapis.com/gwt-releases/gwt-2.6.1.zip"
    printf ">> downloading complete\n"
    
    unzip "gwt-2.6.1.zip"
    cd "gwt-2.6.1"
    
    cp "gwt-codeserver.jar" "../../"
    cp "gwt-dev.jar" "../../"
    cp "gwt-user.jar" "../../"
    
    cd "../../"
    rm -rf "temp"
    
    printf ">> environment preparing completed\n\n" 
fi
