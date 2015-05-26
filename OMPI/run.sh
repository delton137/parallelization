#PBS -W group_list=watermd
#PBS -l nodes=1:ppn=3:b
#PBS -N parallelTest
#PBS -j oe
# Send me mail on job start, job end and if job aborts
#PBS -M delton17@gmail.com
#PBS -m bea

RDIR="/data/delton17/paralleltest"
WDIR="/home/delton17/parallelization_examples/OMPI"

mkdir $RDIR

cp $WDIR/* $RDIR 
cd $RDIR 

#Run
mpiexec -comm pmi ./hello.o > $RDIR/matmul.out

cp $RDIR/* $WDIR
rm -r $RDIR 
