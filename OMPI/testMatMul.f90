program testMatMul
!Dan Elton 12/17/13
!
!This program illustrates some basic MPI techniques
!It first tries multiplying a matrix A by a matrix B through method I
!-- Method I:
!-- The matrix is initialized seperately on each node
!-- Each node takes a fraction of the rows and multiplies those rows by B 
!-- The result of the multiplication is sent to the master node (node 0) 
!-- After the master node has recieved all the rows, it reports the result. 
  use mpi
  implicit none
  integer, parameter :: N=10 !size of the matrices
  real :: A(N,N), B(N,N), C(N,N)
  real :: trace, testsum 
  real, allocatable :: mypart(:,:), lastpart(:,:)
  integer :: ierr,pid,nprocs,be,en,span,i,j,remainder,MPI_status

  call MPI_Init(ierr) !start MPI
  call MPI_Comm_Rank(MPI_COMM_WORLD, pid, ierr) !get processor id
  call MPI_Comm_Size(MPI_COMM_WORLD, nprocs, ierr) !get number of processors

  !initialize matrices 
  do i = 1, N
     do j = 1, N
        A(i,j) = real(i + j)
     enddo
  enddo
  A = B 

  !multiply rows
  span = floor(real(N/nprocs))
  remainder = mod(N,nprocs)

  write(*,*) "hello from process ", pid

  !this part is executed on the non-master nodes
  if (pid .ne. 0) then
    allocate(mypart(span,N))  
    be = 1 + (pid-1)*span
    en = 1 + pid*span

    mypart = matmul(A(be:en,:),B)

    !The MPI send command - sends 'mypart' to the master node (node 0)
    call MPI_Send( mypart, span*N, MPI_REAL, 0, MPI_ANY_TAG, MPI_COMM_WORLD, ierr)
 
   endif 
  
  !this part is executed on the master node
  !the master node is responsible for calculating the last rows of the matrix
  !including any remainder rows. For instance, for 10x10 matrices being multiplied using 3 processors
  !two nodes do 3 rows each and the master node does 3+1=4 rows

  if (pid .eq. 0) then
    allocate(mypart(span,N))  
    allocate(lastpart(span+remainder,N))  
    be = N - span - remainder 
    en = N
    
    lastpart = matmul(A(be:en,:),B)

    !put the 'last part' into C here. Sorry if this is confusing. 
    C(be:en,:) = lastpart
  

    !assemble the solution matrix C
    do i = 1,nprocs-1
      call MPI_Recv( mypart, span*N, MPI_REAL, i, MPI_ANY_TAG, MPI_COMM_WORLD,MPI_status, ierr)
      be = 1 + (i-1)*span
      en = 1 + i*span
      
      C(be:en,:) = mypart
    enddo 

    !compute the sum of the elements and the trace of C and output these quantities
    testsum = 0
    trace = 0 
    do i = 1,N
        trace = trace + C(i,i)
        do j = 1, N
            testsum = testsum + C(i,j)
        enddo
    enddo
    write(*,*) "The trace is ", trace
    write(*,*) "The element sum is ", testsum
  endif 
  !a barrier is placed here just as a good practice 
  !the barrier forces all nodes at the barrier until all nodes reach the barrier



  call MPI_Finalize(ierr)
end program testMatMul
