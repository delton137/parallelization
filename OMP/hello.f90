!-----------------------------------------------
!OMP "Hello World" program
!2013 Dan Elton 
!-----------------------------------------------

program hello

  !$OMP parallel
     np = omp_get_num_threads()
    iam = omp_get_thread_num()

   print *, "Hello world"
  !$OMP end parallel

end program hello

