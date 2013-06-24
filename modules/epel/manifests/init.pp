class epel {
  #currently only supports centos

  yumrepo {"epel":
    #mirrorlist => "${aarnet}/epel/6/${architecture}",
    #mirrorlist => "http://mirrors.fedoraproject.org/publiclist/EPEL/6/x86_64/",
    mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-6&amp;arch=x86_64",
    descr => "EPEL 6 x86_64 repository",
    enabled => "1",
    gpgcheck => "1",
    gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6",
    require => Package["epel-release-6-8"],
  }

  #This package contains the gpg key (which we want), 
  #plus the repo which i don't want. 
  #standard epel repo removed by disableepelrepo module
  package {"epel-release-6-8":
    provider => "rpm",
    ensure => "installed",
    source => "/opt/epel-release-6-8.noarch.rpm",
    require => File["/opt/epel-release-6-8.noarch.rpm"],
  }

  file {"/opt/epel-release-6-8.noarch.rpm":
    ensure => file,
    source => "puppet:///modules/epel/epel-release-6-8.noarch.rpm",
  }

}
