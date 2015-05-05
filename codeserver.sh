#!/bin/bash
./envprepare.sh

if [ $# -eq 0 ]; then
    echo ">> GWT code server util"
    echo ">> allowed commands:"
    echo ">>   1) start"
    echo ">>   params:" 
    echo ">>     - java project absolute source directory with /src/main/java/ at the end"
    echo ">>     - GWT module name, started with package, for search *.gwt.xml config file"
    echo ">>     - java project build WEB-INF directory"
    echo ">>   2) stop:  ./codeserver stop"
    exit 1
fi

if [ $1 == "start" ]; then
    if [ -n "$2" ] && [ -d $2 ]; then
        javaSrcDir=$2
        echo ">> java source dir:              $javaSrcDir"
    else
        echo ">> please, specify correct java source dir."
        exit 1
    fi

    if [ -n "$3" ]; then    
        gwtModule=$3
        echo ">> GWT module name:              $gwtModule"
    else
        echo ">> please, specify GWT module name"    
        exit 1  
    fi
    
    if [ -n "$4" ] && [ -d $4 ]; then
        webInfDir=$4
        echo ">> webclient build WEB-INF dir:  $webInfDir"
    else
        echo ">> please, specify correct webclient build WEB-INF diectory"
        exit 1
    fi

    printf "\n>> starting GWT code server. Server output: \n\n"
    
    classPath="${webInfDir}classes:"
    
    if [ -d "${webInfDir}../../generated-sources/gwt" ]; then
        classPath="${classPath}${webInfDir}../../generated-sources/gwt:"
    fi
    
    for jar in *.jar; do
        classPath="$classPath$jar:"
    done
    
    classPath="$classPath${webInfDir}lib/*"
    
    serverMainClass="com.google.gwt.dev.codeserver.CodeServer"
    serverParams="-bindAddress 127.0.0.1 -port 9876 -src $javaSrcDir $gwtModule"
    jvmArgs="-Xmx1024m -Xmn256m -Xms400m -Xss20M"

    java $jvmArgs -cp $classPath $serverMainClass $serverParams 
    echo ">> done"
else
    echo ">> stopping GWT code server"
    
    pids=$(ps ax | grep "codeserver" | grep -v grep | grep -v gedit | cut -d ' ' -f1)
    for pid in $pids; do
        if [ "$$" != "$pid" ]; then
            sudo kill $pid
        fi
    done
    echo ">> done"      
fi
