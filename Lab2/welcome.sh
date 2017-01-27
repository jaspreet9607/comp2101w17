#!/bin/bash
#this script prints out a welcome message
#it demonstrates using variables

export MYNAME="Jaspreet"
mytitle="Playboy"

myhostname=`hostname`
dayoftheweek=$(date +%A)

echo "Welcome to my world $myhostname, $mytitle $MYNAME!"
echo "Today is $dayoftheweek."
