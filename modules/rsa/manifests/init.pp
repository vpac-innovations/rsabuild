class rsa {
  # currently only supports centos
  
  include epel
  include elgisrepos 
  include postgresql

  class { 'postgresql::server':
    config_hash => {
        'ip_mask_deny_postgres_user' => '0.0.0.0/32',
        'ip_mask_allow_all_users' => '0.0.0.0/0',
        'listen_addresses' => '*',
        'manage_redhat_firewall' => true,
        'postgres_password' => 'postgres',
    },
  }

  postgresql::db { 'uladb':
    user     => 'ula',
    password => 'password',
    grant    => 'all',
  }

  package {"java-1.7.0-openjdk":
    ensure => installed,
  }

  # required for building rsa
  package {"java-1.7.0-openjdk-devel":
    ensure => installed,
  }

  class {'developmenttools': }

  package {"swig":
    ensure => installed,
  }

  package {"ant":
    ensure => installed,
  }

  # required for building rsa as ant using symlink target element
  package {"ant-nodeps":
    ensure => installed,
  }

  # required for building rsa as ant using junit target element
  package {"ant-junit":
    ensure => installed,
  }

  package {"proj-devel":
    ensure => installed,
  }

  $gdal_checkout="/usr/local/src/gdal-trunk"
  $gdal_checkout_revision="26089"
  $gdal_repo="https://svn.osgeo.org/gdal/trunk"
  $gdal_java_opt="/usr/local/src/gdal-trunk/gdal/swig/java/java.opt"
  $usr_local="/usr/local"
  $usr_local_src="/usr/local/src"
  $gdal_make="/usr/local/src/gdal-trunk/gdal"
  $gdal_java="/usr/local/src/gdal-trunk/gdal/swig/java"

  # get gdal using svn checkout
  vcsrepo {$gdal_checkout:
    ensure => present,
    provider => svn,
    source => $gdal_repo,
    revision => $gdal_checkout_revision,
  }

  # point gdal java.opt configuration option to the installed java installation
  file{"java_opt":
    ensure => present,
    path => $gdal_java_opt,
    content => "JAVA_HOME=/etc/alternatives/java
JAVADOC=$(JAVA_HOME)/bin/javadoc
JAVAC=$(JAVA_HOME)/bin/javac
JAVA=$(JAVA_HOME)/bin/java
JAR=$(JAVA_HOME)/bin/jar
JAVA_INCLUDE=-I/usr/lib/jvm/java/include -I/usr/lib/jvm/java/include/linux
",
    before => Exec["configure_gdal"],
  }

  # configure gdal
  exec {"configure_gdal":
    command => "bash configure --with-netcdf=$usr_local --with-hdf5=$usr_local",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $gdal_make,
    before => Exec["make_gdal"],
  }

  # make gdal
  exec {"make_gdal":
    command => "make",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $gdal_make,
    before => Exec["install_gdal"],
  }

  # install gdal
  exec {"install_gdal":
    command => "make install",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $gdal_make,
    before => Exec["make_gdal_java"],
  }

  # make gdal java binding
  exec {"make_gdal_java":
    command => "make",
    timeout => 0,
    environment => ['CPPFLAGS="-I/usr/lib/jvm/java/include -I/usr/lib/jvm/java/include/linux"'],
    path => ["/bin","/usr/bin"],
    cwd => $gdal_java,
    before => Exec["copy_gdal_java"],
  }

  $export_gdal_sh="/etc/profile.d/export_gdal.sh"

  file{"export_gdal_sh":
    ensure => present,
    path => $export_gdal_sh,
    # use ' to make escape puppet interpretation
    content => '#!/bin/sh

GDAL_DIR=/usr/local
export PATH=$GDAL_DIR/bin:$PATH
export LD_LIBRARY_PATH=$GDAL_DIR/lib:$LD_LIBRARY_PATH
',
    mode => 755,
    require => Exec["make_gdal_java"],
  }

  # create symlink for libraries
  file { '/usr/local/lib/libgdalconstjni.so.1':
    ensure => 'link',
    target => '/usr/local/lib/libgdalconstjni.so',
    require => Exec["copy_gdal_java"],
  }

  file { '/usr/local/lib/libgdaljni.so.1':
    ensure => 'link',
    target => '/usr/local/lib/libgdaljni.so',
    require => Exec["copy_gdal_java"],
  }

  file { '/usr/local/lib/libogrjni.so.1':
    ensure => 'link',
    target => '/usr/local/lib/libogrjni.so',
    require => Exec["copy_gdal_java"],
  }

  file { '/usr/local/lib/libosrjni.so.1':
    ensure => 'link',
    target => '/usr/local/lib/libosrjni.so',
    require => Exec["copy_gdal_java"],
  }

  # copy all gdal jars into /usr/local/lib
  exec {"copy_gdal_java":
    command => "cp *.jar *.so $usr_local/lib/",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $gdal_java,
    before => Exec["enable_gdal"],
  }

  # update PATH and LD_LIBRARY_PATH to include gdal 
  exec {"enable_gdal":
    command => "bash $export_gdal_sh",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    require => File["export_gdal_sh"],
  }

  # get zlib 1.2.7 (version 1.2.5+ required)
  $zlib = "zlib-1.2.7.tar.gz"
  $zlib_dir="/usr/local/src/zlib-1.2.7"
  file { 'zlib':
    path    => "${usr_local_src}/${zlib}",
    ensure  => file,
    source  => "puppet:///modules/rsa/${zlib}",
    before => Exec['tar_zlib'],
  }

  # unzip into /usr/local/src/zlib-1.2.7
  exec {"tar_zlib":
    command => "tar -xf ${usr_local_src}/${zlib}",
    unless => ["test -d $zlib_dir"],
    path => ["/bin","/usr/bin"],
    creates => "${zlib_dir}/configure",
    cwd => "${usr_local_src}",
    before => Exec["configure_zlib"],
  }

  # configure zlib
  exec {"configure_zlib":
    #command => "bash configure --prefix=$usr_local",
    command => "bash configure",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $zlib_dir,
    before => Exec["install_zlib"],
  }

  # make & install zlib
  exec {"install_zlib":
    command => "make install",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $zlib_dir,
  }

  # get hdf5 1.8.9 (version 1.8.6+ required)
  $hdf5 = "hdf5-1.8.9.tar.gz"
  $hdf5_dir="/usr/local/src/hdf5-1.8.9"
  file { 'hdf5':
    path    => "${usr_local_src}/${hdf5}",
    ensure  => file,
    source  => "puppet:///modules/rsa/${hdf5}",
    before => Exec['tar_hdf5'],
  }

  # unzip into /usr/local/src/hdf5-1.8.9
  exec {"tar_hdf5":
    command => "tar -xf ${usr_local_src}/${hdf5}",
    unless => ["test -d $hdf5_dir"],
    path => ["/bin","/usr/bin"],
    creates => "${hdf5_dir}/configure",
    cwd => "${usr_local_src}",
    before => Exec["configure_hdf5"],
  }

  # configure hdf5
  exec {"configure_hdf5":
    command => "bash configure --prefix=$usr_local --with-zlib=$usr_local",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $hdf5_dir,
    before => Exec["install_hdf5"],
  }

  # make & install hdf5
  exec {"install_hdf5":
    command => "make install",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $hdf5_dir,
  }

  # get latest netcdf (version 4.3.0+ required)
  $nc = "netcdf-4.3.0.tar.gz"
  $nc_dir="/usr/local/src/netcdf-4.3.0"
  file {"nc":
    path    => "${usr_local_src}/${nc}",
    ensure  => file,
    source  => "puppet:///modules/rsa/${nc}",
    before => Exec['tar_nc'],
  }

  # unzip into /usr/local/src/netcdf-4.3.0
  exec {"tar_nc":
    command => "tar -xf ${usr_local_src}/${nc}",
    unless => ["test -d $nc_dir"],
    path => ["/bin","/usr/bin"],
    creates => "${nc_dir}/configure",
    cwd => "${usr_local_src}",
    before => Exec["configure_nc"],
  }

  # configure netcdf
  exec {"configure_nc":
    #command => "bash configure --prefix=$usr_local --enable-cxx-4",
    command => "bash configure --prefix=$usr_local",
    environment => ['CPPFLAGS=-I/usr/local/include', 'LDFLAGS=-L/usr/local/lib'],
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $nc_dir,
    before => Exec["install_nc"],
  }

  # make & install netcdf
  exec {"install_nc":
    command => "make install",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $nc_dir,
  }

  $rsa_checkout="/usr/local/src/rsa"

  # checkout rsa repository
  vcsrepo {"/usr/local/src/rsa":
    ensure => present,
    provider => git,
    source => 'git://github.com/VPAC/rsa.git',
    revision => 'HEAD',
    before => Exec["update_rsa"],
  }

  # update rsa 
  exec {"update_rsa":
    command => "git pull --quiet",
    onlyif => ["test -d $rsa_checkout"],
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $rsa_checkout,
    before => Exec["build_rsa"],
  }

  $rsa_src="/usr/local/src/rsa/src"
  $java_sdk="/etc/alternatives/java_sdk"

  # build rsa using its ant build script
  exec {"build_rsa":
    command => "ant -quiet",
    environment => ["JAVA_HOME=$java_sdk"],
    onlyif => ["test -d $rsa_src"],
    timeout => 0,
    path => ["/bin","/usr/bin"],
    cwd => $rsa_src,
  }

  # Create rsa directories
  $rsa_dirs = [ '/var/lib/ndg', '/var/lib/ndg/storagepool', 
		'/var/tmp/ndg', 
		'/var/spool/ndg', '/var/spool/ndg/upload', 
		'/var/spool/ndg/pickup'
	      ]

  file {$rsa_dirs:
    ensure => "directory",
    mode   => 775,
    require => Exec["enable_rsacli"],
  }

  $export_rsacli_sh="/etc/profile.d/export_rsacli.sh"

  file{"export_rsacli_sh":
    ensure => present,
    path => $export_rsacli_sh,
    # use ' to make escape puppet interpretation
    content => '#!/bin/sh

RSACLI_DIST=/usr/local/src/rsa/src/cmdclient/dist/rsacli
export PATH=$RSACLI_DIST:$PATH
export LD_LIBRARY_PATH=$RSACLI_DIST/lib:$LD_LIBRARY_PATH
',
    mode => 755,
  }

  # update PATH and LD_LIBRARY_PATH to include rsacli 
  exec {"enable_rsacli":
    command => "bash $export_rsacli_sh",
    timeout => 0,
    path => ["/bin","/usr/bin"],
    require => File["export_rsacli_sh"],
  }

  # iptables firewall is messing port forwarding in Vagrant running CentOS so disable it
  class disable_iptables {
    service {'iptables':
      ensure => stopped,
    }
  }

  # declaring above class as resource
  class {'disable_iptables':}

  $tomcat_webapp_dir="/usr/share/tomcat6/webapps"

  # iptables firewall is messing port forwarding in Vagrant running CentOS so disable it
  class delete_spatialcubeservice {
    file {'/usr/share/tomcat6/webapps/spatialcubeservice.war':
      ensure => absent,
    }

    file {'/usr/share/tomcat6/webapps/spatialcubeservice':
      ensure => absent,
      force => true,
    }

  }

  # declaring above class as resource
  class {'delete_spatialcubeservice':}

  $rsa_dist="/usr/local/src/rsa/src/dist"

  exec {"spatialcubeservice_war":
    command => "cp spatialcubeservice_*.war spatialcubeservice.war",
    cwd => "$rsa_dist",
    onlyif => ["test -d $rsa_dist"],
    timeout => 0,
    path => ["/bin","/usr/bin"],
    require => Class["delete_spatialcubeservice"],
  }

  $servlet_src="$rsa_dist/spatialcubeservice.war"
  tomcat::deployment {"spatialcubeservice":
    path => $servlet_src,
  }

  Exec["install_zlib"] -> Exec["install_hdf5"] -> Exec["install_nc"] -> Exec["install_gdal"] -> Exec["make_gdal_java"] -> Exec["enable_gdal"] -> Exec["build_rsa"] -> Exec["enable_rsacli"] -> Exec["spatialcubeservice_war"] -> Tomcat::Deployment["spatialcubeservice"] -> Class["disable_iptables"]

}
