!------------------------------------
!MPI "Hello world" program
!2013 Dan Elton 
!This is licensed under the GNU LGPL v3 license 
!------------------------------------

program hello

  use mpi

  implicit none

  integer :: ierr
  integer :: mype
  integer :: nprocs

  call MPI_Init(ierr)

  call MPI_Comm_Rank(MPI_COMM_WORLD, mype, ierr)
  call MPI_Comm_Size(MPI_COMM_WORLD, nprocs, ierr)

  write(*,*) "Hellow from processor", mype
  write(*,*) "Running Hello, World on ", nprocs, " processors"
  

  print *, "Hello World", mype
  print *, char(7) 
  call MPI_Finalize(ierr)

end program hello
