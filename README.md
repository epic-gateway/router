# EGW Router

Project for development of EGW router container

 Note that the binaries of bird are not located in the directory.  BIRD
 needs to be built on the OS used by the container.  The dockerfile
 assumes that you have built BIRD on an OS matching the FROM ubuntu label 
 and copied the binaries into the dockerfile directory before creating. 
 
 Only two bird binaries are required, bird and birdc