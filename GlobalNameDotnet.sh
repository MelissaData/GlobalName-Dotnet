#!/bin/bash

# Builds and runs the Melissa Global Name Cloud API .NET sample.
#
# This script builds GlobalNameDotnet with dotnet publish, then runs the resulting
# executable, passing along the license and (if supplied) the full name.
#
# Overall flow:
#   1. Parse the command-line options below.
#   2. Resolve the license (--license, then a prompt, then the MD_LICENSE environment variable).
#   3. Publish GlobalNameDotnet in Release configuration to ./GlobalNameDotnet/Build.
#   4. Run the built executable: one-shot mode if the full name was supplied,
#      otherwise interactive mode (the .NET program prompts for it).
#
# Options (each takes a value):
#   --fullname   Full name to parse.
#   --license    License string. If omitted, the script prompts for it; if the prompt
#                is left blank, it falls back to MD_LICENSE. Running without --license
#                always prompts, even when MD_LICENSE is set.
#
# Paths are relative to the current directory, so run the script from its own folder.
#
# Examples:
#   ./GlobalNameDotnet.sh --license "your-license"
#   ./GlobalNameDotnet.sh --fullname "Raymond Melissa" --license "your-license"

######################### Constants ##########################

RED='\033[0;31m' #RED
NC='\033[0m' # No Color

######################### Parameters ##########################

fullname=""
license=""

# Read each --flag and its value. A flag with no value, or whose value starts
# with "-", is an error. Unrecognized options are ignored.
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

# Build paths are relative to the current directory (not the script's location)
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
# No full name supplied -> run interactively; otherwise pass it through for one-shot mode.
if [ -z "$fullname" ];
then
    dotnet "$BuildPath"/GlobalNameDotnet.dll --license "$license"
else
    dotnet "$BuildPath"/GlobalNameDotnet.dll --license "$license" --fullname "$fullname"
fi


