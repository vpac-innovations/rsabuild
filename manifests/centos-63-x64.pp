
   group { "puppet":
     ensure => "present",
   }
  
  # # File { owner => 0, group => 0, mode => 0644 }
  
  file { '/etc/motd':
    content => "\n\tWelcome to your newly built CentOS 6.3 guest VM with RSA installed!
                 Produced by VPAC\n
	To get started with rsacli:
		$ rsa -h		# see a complete list of usage
		$ rsa dataset list	# list all available datasets\n
	To get started with spatialcubeservice:
		http://localhost:8080/spatialcubeservice/Dataset.xml\n
	To get started with query:
		http://localhost:8080/spatialcubeservice/app/index.html\n
	As port 8080 is being forwarded to host port 8181, you can directly open below using port 8181 on host machine:
		http://localhost:8181/spatialcubeservice/Dataset.xml\n\n"
   }

  include rsa  
