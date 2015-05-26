!---------------------------------------------------------------------------------------------
!Matrix multiplication example of the GATHER() MPI command
!Dan Elton 12/15/13
!Finished  --/--/15
!Based on C code by --  
!! This program splits up a matrix multplication problem, passing a copy of the matrix to each process 
!! It parallelizes over the rows of the matrix. For instance, for squaring a 100x100 matrix (default) with 4 processors
!! each processor multiplies ( 25x100 ) * (100x100)
!! It uses the 'GATHER' command to gather the rows together to report the output. 
!! To check the output, the trace of the matrix is computed
!! The total walltime time for execution is reported at the end. 
!--------------------------------------------------------------------------------------------

program gather
  use mpi
  implicit none
  integer, parameter :: N = 1000
  double precision A(N,N), B(N,N), C(N,N), trace
  integer :: i, j, rows_to_do
  integer :: ierr, mypid, nprocs
 

  !initialize the matrices
  do j = 1, N
     do i = 1, N
        A(i,j) = dble(i + j)
     enddo
  enddo
  A = B 
  
  call MPI_Init(ierr)
  call MPI_Comm_Rank(MPI_COMM_WORLD, mypid, ierr)
  call MPI_Comm_Size(MPI_COMM_WORLD, nprocs, ierr)

  rows_to_do = Floor(N/nprocs)
  remain = mod(N,nprocs)

  !Do part of the matrix multiplication
  if (mypid .ne. nprocs) then 
    do i = mypid*rows_to_do+1, (mypid+1)*rows_to_do 
      do j = 1, N
        C(i,j) = A(i,j)*B(j,i)
      enddo 
    enddo 
  endif
  if (mypid .eq. 0) then 
    do i = mypid*rows_to_do+1, (mypid+1)*rows_to_do + remain
      do j = 1, N
        C(i,j) = A(i,j)*B(j,i)
      enddo
    enddo 
  endif
 
  !GATHER() the data from the different processes

  !find the trace and the checksum
  trace = 0  
  checksum = 0 
  do i = 1, N
    trace = trace + C(i,i)
    do j = 1, N
      checksum = checksum + C(i,j)
    enddo
  enddo 
  write(*,*) "the trace is", trace
  write(*,*) "the checksum is", checksum

  call MPI_Finalize(ierr)
end progriam hello
