#!/bin/bash

# Get the list of process IDs (PIDs) for processes in a zombie state
zombie_pids=$(ps -eo pid,state | awk '$2=="Z" {print $1}')
#ps -eo pid,state -> gives the list of all the process IDs and their state
#awk '$2=="Z" {print $1}' -> awk is trying to query on top of the content gathered from | 
# $2=="Z" refers to second column of the previous output which is the state of the process
# The above line fetches all the process whose state is Z which is Zombie
# {print $1} prints the 1st column of those processes which is the pid

# Check if there are any zombie processes
if [ -z "$zombie_pids" ]; then
  echo "No zombie processes found."
else
  echo "Zombie processes found:"
  echo "$zombie_pids"
fi
