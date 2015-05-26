#!/bin/bash
#Dec. 2013 D. Elton
#This is a script for quickly testing MPI codes 
#This script requires an input which is the program name 
#The input argument is automatically stored in the variable $1 by BaSh

#remove the ".f90" suffix from the filename
Name=`echo ${1%.*}`
if [[ $1 = $2 ]]; then 
  echo "ERROR: You forgot to supply the *.f90 filename as an argument!"
  exit 1
fi 

#Compile 
mpif90  $1 -o $Name.o #f90=ifort -O3 > $STUFF

#Check if compilation was OK
if [ $? -ne 0 ]
then
    echo "ERROR: Compilation Failed! Stopping script."
    exit 1
fi

PWD2=`pwd`
echo PWD2
#Set up PBS Script 
sed "s/Name=/Name=$Name/g" runMPI.sh -i
sed "s/ -N / -N $Name/g" runMPI.sh -i
#sed "s/WDIR= / WDIR=$PWD2 /g" runMPI.sh -i
wait

#Submit PBS Script
qsub runMPI.sh

#sleep(1)

#reset PBS script
sed "s/Name=$Name/Name=/g" runMPI.sh -i
sed "s/ -N $Name/ -N /g" runMPI.sh -i
#sed "s/WDIR=$PWD2 / WDIR= /g" runMPI.sh -i

echo "All Done!"

