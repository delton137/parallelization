!-------------------------------------------------------------------
!  This is a simple send/receive program using OMPI
!  Processor 0 sends part of a 3x4xNnodes *array* called "RR" to each processor
!  while each processor receives the subarray and writes it out.  
!  Dan Elton Jan 2014
!-------------------------------------------------------------------

program arraytest
use mpi
Implicit none
double precision, allocatable, dimension(:,:,:) :: RRt
double precision, allocatable, dimension(:,:) :: RR
integer pid, ierr, Nnodes
integer i,j, status2, counti
integer ArrayType

call MPI_INIT( ierr )
call MPI_COMM_RANK( MPI_COMM_WORLD, pid, ierr )
call MPI_COMM_SIZE( MPI_COMM_WORLD, Nnodes, ierr )
write(*,*) "MPI Initialized OK on node ", pid, " out of ", Nnodes

!local array
allocate(RR(3,4))
!"total" array 
allocate(RRt(3,4,Nnodes))
counti = 3*4

if (pid == 0) then

	do i = 1,Nnodes-1
		RRt(1,:,i) = (/ .11d0, .12d0, .13d0, .14d0 /)   
		RRt(2,:,i) = (/ .21d0, .22d0, .23d0, .24d0 /)     
		RRt(3,:,i) = (/ .31d0, .32d0, .33d0, .34d0 /)   
		RRt(:,:,i) = RRt(:,:,i) + i
	enddo               
	do i = 1, Nnodes-1
		Call MPI_Send(RRt(:,:,i), counti, MPI_DOUBLE_PRECISION,i, MPI_ANY_TAG, MPI_COMM_WORLD, ierr)    
		write(*,*) "Sent to node ", i   
    	enddo
	do i = 1, Nnodes-1
		call MPI_Recv(RRt(:,:,i), counti, MPI_DOUBLE_PRECISION,i, MPI_ANY_TAG, MPI_COMM_WORLD,status2,ierr)  
		write(*,*) "recieved from node ", i     
    	enddo
	do i =1,Nnodes-1
		write(*,*) "Sub Array ", i
		write(*,*) RRt(1,:,i)
		write(*,*) RRt(2,:,i)
		write(*,*) RRt(3,:,i)
	enddo
else
	write(*,*) "Hello from node ", pid 
	Call MPI_Recv(RR, counti, MPI_DOUBLE_PRECISION,0, MPI_ANY_TAG, MPI_COMM_WORLD,status2,ierr)
       	write(*,*)"processor ", pid, "recieved RR "
	RR = RR*real(pid)
 	Call MPI_Send(RR, counti, MPI_DOUBLE_PRECISION,0, MPI_ANY_TAG, MPI_COMM_WORLD, ierr)   
	write(*,*)"processor ", pid, "sent RR "    
endif

call MPI_FINALIZE(ierr)
      
end program

