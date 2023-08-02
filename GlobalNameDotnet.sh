#!/bin/bash

# Name:    GlobalNameCloudAPI
# Purpose: Execute the GlobalNameCloudAPI program

######################### Constants ##########################

RED='\033[0;31m' #RED
NC='\033[0m' # No Color

######################### Parameters ##########################

fullname=""
license=""

while [ $# -gt 0 ] ; do
  case $1 in
    --fullname) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'fullname\'.${NC}\n"  
            exit 1
        fi 

        fullname="$2"
        shift
        ;;
    --license) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'license\'.${NC}\n"  
            exit 1
        fi 

        license="$2"
        shift 
        ;;
  esac
  shift
done

# Use the location of the .sh file
# Modify this if you want to use
CurrentPath="$(pwd)"
ProjectPath="$CurrentPath/GlobalNameDotnet"
BuildPath="$ProjectPath/Build"

if [ ! -d "$BuildPath" ];
then
    mkdir "$BuildPath"
fi

########################## Main ############################
printf "\n==================== Melissa Global Name Cloud API =====================\n"

# Get license (either from parameters or user input)
if [ -z "$license" ];
then
  printf "Please enter your license string: "
  read license
fi

# Check for License from Environment Variables 
if [ -z "$license" ];
then
  license=`echo $MD_LICENSE` 
fi

if [ -z "$license" ];
then
  printf "\nLicense String is invalid!\n"
  exit 1
fi

# Start program
# Build project
printf "\n============================= BUILD PROJECT ============================\n"

dotnet publish -f="net7.0" -c Release -o "$BuildPath" GlobalNameDotnet/GlobalNameDotnet.csproj

# Run project
if [ -z "$fullname" ];
then
    dotnet "$BuildPath"/GlobalNameDotnet.dll --license $license 
else
    dotnet "$BuildPath"/GlobalNameDotnet.dll --license $license --fullname "$fullname"
fi


