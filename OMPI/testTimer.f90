!Dan Elton 12/19/13
!
!This program tests the OMPI timer feature 
!and compares it with CPU timestamp outputs 
! 
program testSendRecv  
  use mpi
  implicit none
  double precision  :: t1, t2
  double precision :: MPI_Wtime
  integer :: pid, nprocs, ierr

  call MPI_Init(ierr) !start MPI
  call MPI_Comm_Rank(MPI_COMM_WORLD, pid, ierr) !get processor id
  call MPI_Comm_Size(MPI_COMM_WORLD, nprocs, ierr) !get number of processors

   
    t1 = MPI_Wtime()
    call  sleep(10)
    t2 = MPI_Wtime()
   write(*,*) "Exectuation time = ", t2-t1
   write(*,*) "From node", pid, " of ", nprocs 


  call MPI_Finalize(ierr)
end program testSendRecv
