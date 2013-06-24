# Building RSA and its environment using Vagrant:

 1. Install vagrant as shown [here](http://docs.vagrantup.com/v2/installation/index.html) or using the following instructions.
 
	Debian/Ubuntu:
	
	```
	$ sudo apt-get install virtualbox
	$ sudo apt-get install vagrant
	```
 	
 2. Get rsabuild vagrant and puppet scripts from GitHub repository:

		$ git clone git@github.com:VPAC/rsabuild.git
		$ cd rsabuild					# Go into rsabuild directory
	
 3. Load up a guest VM using Vagrant by running:
		
		$ vagrant up
	

	Once the above command finished running, you'll will have a fully running Centos 6.3 VM with RSA installed.
	
	Once you ssh into the guest VM, you should see this usage below:

	```
	$ vagrant ssh
	
	Welcome to your newly built CentOS 6.3 guest VM with RSA installed!
                 Produced by VPAC

	To get started with rsacli:
		$ rsa -h					# see a complete list of usage
		$ rsa dataset list			# list all available datasets

	To get started with spatialcubeservice:
		$ curl http://localhost:8080/spatialcubeservice/Dataset.xml

	```
	As port `8080` is being forwarded to host port `8181`, you can access below URL from host machine directly using port 8181:
	
		http://localhost:8181/spatialcubeservice/Dataset.xml
		
	To get started with query from host machine:
	
		http://localhost:8181/spatialcubeservice/app/index.html

### Commonly used vagrant commands:

	$ vagrant ssh		# SSH into the guest VM.

	$ vagrant up		# Install all dependencies and load the guest VM.

	$ vagrant provision	# Apply changes to the guest VM.

	$ vagrant reload	# Reload the guest VM.

	$ vagrant destroy	# Destroy the guest VM.

	$ vagrant suspend	# Suspend the guest VM rather than fully destroying it.

	$ vagrant resume	# Resume a Vagrant managed VM that was previously suspended.

	$ vagrant status	# Show the state of the VMs Vagrant is managing.

	$ vagrant init centos-63-x64 http://vpac.org/pub/centos-63-x64.box # Create the VM from the specified box

## License & Acknowledgements

Copyright 2013 [CRCSI][1] - Cooperative Research Centre for Spatial Information.

rsabuild is free software: you can redistribute it and/or modify it under the terms of the GNU General Public Licence as published by the Free Software Foundation, either version 3 of the Licence, or (at your option) any later version. See [LICENCE.txt](LICENSE.txt).

rsabuild is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

rsabuild was developed by VPAC under the [Unlocking the Landsat Archive (ULA)][2] project as funded by the Australian Space Research Program (ASRP).

[1]: http://www.crcsi.com.au/
[2]: http://www.space.gov.au/AustralianSpaceResearchProgram/ProjectFactsheetspage/Pages/UnlockingtheLANDSATArchiveforFutureChallenges.aspx

This project includes some third party software under different licenses.
