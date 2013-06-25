
   group { "puppet":
     ensure => "present",
   }
  
  # # File { owner => 0, group => 0, mode => 0644 }
  
  file { '/etc/motd':
    content => "\n\tWelcome to your newly built CentOS 6.3 guest VM with RSA installed!
                 Produced by VPAC\n
	To get started with rsacli:
		$ rsa -h			# see a complete list of usage
		$ rsa dataset list		# list all available datasets\n
	To get started with spatialcubeservice:
		$ curl http://localhost:8080/spatialcubeservice/Dataset.xml\n
	As port 8080 is being forwarded to host port 8181, you can access below URL from host machine directly using port 8181:
		http://localhost:8181/spatialcubeservice/Dataset.xml\n
	To get started with query from host machine, access below URL with web browser:
		http://localhost:8181/spatialcubeservice/app/index.html\n\n"

   }

  include rsa  
