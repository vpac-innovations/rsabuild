class developmenttools {

  package {"autoconf":
    ensure => installed,
  }
  package {"automake":
    ensure => installed,
  }
  package {"binutils":
    ensure => installed,
  }
  package {"bison":
    ensure => installed,
  }
  package {"flex":
    ensure => installed,
  }
  package {"gcc":
    ensure => installed,
  }
  package {"gcc-c++":
    ensure => installed,
  }
  package {"gettext":
    ensure => installed,
  }
  package {"libtool":
    ensure => installed,
  }
  package {"make":
    ensure => installed,
  }
  package {"patch":
    ensure => installed,
  }
  package {"pkgconfig":
    ensure => installed,
  }
  package {"redhat-rpm-config":
    ensure => installed,
  }
  package {"rpm-build":
    ensure => installed,
  }
  package {"subversion":
    ensure => installed,
  }
  package {"git":
    ensure => installed,
  }
  package {"tar":
    ensure => installed,
  }
  package {"nc":
    ensure => installed,
  }
}

