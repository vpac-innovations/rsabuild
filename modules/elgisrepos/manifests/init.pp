class elgisrepos {
  #currently only supports centos

  $elgis="http://elgis.argeo.org/repos/6/" 
  $elgistesting="http://elgis.argeo.org/repos/testing" 

  #This package contains the gpg key (which we want), 
  #plus the repo which i don't want. 
  #standard epel repo removed by disableepelrepo module
  #package {"elgis-release-6-6_0.noarch.rpm":
  #  provider => "rpm",
  #  ensure => "installed",
  #  source => "/opt/elgis-release-6-6_0.noarch.rpm",
  #  require => File["/opt/elgis-release-6-6_0.noarch.rpm"],
  #}

  #file {"/opt/elgis-release-6-6_0.noarch.rpm":
  #  ensure => file,
  #  source => "puppet:///modules/elgisrepos/elgis-release-6-6_0.noarch.rpm",
  #}

  yumrepo {"elgis-testing":
    baseurl => "${elgistesting}/6/elgis/${architecture}",
    descr => "elgis el6 testing ${architecture} repository",
    enabled => "1",
    gpgcheck => "1",
    gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ELGIS",
    require => File["/etc/pki/rpm-gpg/RPM-GPG-KEY-ELGIS"],
  }

  file {"/etc/pki/rpm-gpg/RPM-GPG-KEY-ELGIS":
    ensure => file,
    source => "puppet:///modules/elgisrepos/RPM-GPG-KEY-ELGIS",
  }

  yumrepo {"elgis":
    baseurl => "${elgis}/elgis/${architecture}",
    descr => "elgis el6 ${architecture} repository",
    enabled => "1",
    gpgcheck => "1",
    gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ELGIS",
    require => File["/etc/pki/rpm-gpg/RPM-GPG-KEY-ELGIS"],
  }

}
