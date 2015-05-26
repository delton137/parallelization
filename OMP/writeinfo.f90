!------------------------------------------------------
!OMP "Hello World" type program that writes info
!2013 Dan Elton
!-----------------------------------------------------

program writeinfo
   use omp_lib    
  implicit none
    integer(2) :: np, nt, mnt, tn
    CHARACTER(30) :: name  

    CALL GET_ENVIRONMENT_VARIABLE("HOSTNAME",name)  
 
    nt  = omp_get_num_threads()
    mnt = omp_get_max_threads()
    tn = omp_get_thread_num()
 
    write(*,*) "Running on", name
    write(*,*) "Using ", nt, "threads out of a maximum of ", mnt
    write(*,*) "The master thread is number ", tn 

    write(*,*) "entering parallel region of code"
  !$OMP parallel private(tn)
    tn =   omp_get_thread_num()
    write(*,*) "hello from thread ", tn, " out of ", mnt 
    
  !$OMP end parallel

 !    write(*,*) "Using ", nt, "threads out of a maximum of "


end program writeinfo

