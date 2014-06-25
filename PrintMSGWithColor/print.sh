#!/bin/bash

# colors                                                                                                                                                      
export RED=$(tput setaf 1)                                                                                                                                    
export GREEN=$(tput setaf 2)                                                                                                                                  
export NORMAL=$(tput sgr0) 

MSG="test print with colors"

let COL=$(tput cols)-${#MSG}+${#RED}+${#NORMAL}
printf "%s%${COL}s" "${MSG}" "${RED}[ERROR]${NORMAL}"

let COL=$(tput cols)-${#MSG}+${#GREEN}+${#NORMAL}
printf "%s%${COL}s" "${MSG}" "${GREEN}[OK]${NORMAL}"
