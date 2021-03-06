#!/usr/bin/env sh
set -eu

module="";
type="";

PRINT_BANNER() {
  echo '
  
 ██████╗██████╗     ███████╗███╗   ███╗██████╗ 
██╔════╝██╔══██╗    ██╔════╝████╗ ████║██╔══██╗
██║     ██████╔╝    ███████╗██╔████╔██║██████╔╝
██║     ██╔══██╗    ╚════██║██║╚██╔╝██║██╔═══╝ 
╚██████╗██████╔╝    ███████║██║ ╚═╝ ██║██║     
 ╚═════╝╚═════╝     ╚══════╝╚═╝     ╚═╝╚═╝     
                                                                           
                                                        
 Generator of message models v.0.1.1 
 =================================================                             
'
}
PRINT_HELP() {
  echo '
Synopsis

  $ generate [-m MODULE] [-t TYPE] 

  MODULE  any module name 
  TYPE    cs|ts
'
}

if [ $# -eq 0 ]; then
  echo "No required arguments"
else
  if [ $1 ] & [ $2 ] & [ $3 ] & [ $4 ]; then
    
    if [ $1 = "-m" ]; then
      if [ $2 ]; then
        module=$2
      fi
    fi
    
    if [ $3 = "-t" ]; then
      if [ $4 ]; then
        type=$4
      fi
    fi

if [ module != "" ] & [ type != "" ]; then

      PRINT_BANNER
      echo " Generates message models of the type [$type] for the module [$module]... wait"
      
      rm -rf ./../../src/Messages
      
      for f in $(find ./modules/$module/ -name '*.json'); do
        
        filename=`basename "${f%%.json}"`
        layername=`basename "${f%%$filename.json}"`
        modulecc=`echo $module | sed -E 's/[ _-]([a-z])/\U\1/gi;s/^([A-Z])/\l\1/'`
        
        
        
        mkdir -p ./../../src/Messages/$modulecc/$layername
    
        echo " Generate models $module/$layername/$filename.$type ..."     
        
        if [ $type = "cs" ]; then
          quicktype -s schema "$f" -o "./../../src/Messages/$modulecc/$layername/$filename.$type" --namespace "Messages.$modulecc" --features just-types-and-namespace --base-class EntityData;  
          
          case $layername in

            dto)
              sed -i 's/EntityData/TResponse/' ./../../src/Messages/$modulecc/$layername/$filename.$type
              ;;
          
            query | command)
              sed -i 's/EntityData/TRequest/' ./../../src/Messages/$modulecc/$layername/$filename.$type
              ;;
          
          esac
           
        fi 
        
        if [ $type = "ts" ]; then
          quicktype -s schema $f -o ./../../src/Messages/$modulecc/$layername/$filename.$type --just-types
        fi
        
        echo " Generate models $module/$layername/$filename.$type ... done"
      done
    fi

    exit 0
    PRINT_HELP

  fi

fi
