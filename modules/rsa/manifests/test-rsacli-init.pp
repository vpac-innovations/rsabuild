class rsa {
  # currently only supports centos
  
  include epel
  include elgisrepos 

  $export_rsacli_sh="/etc/profile.d/export_rsacli.sh"

  file{"export_rsacli_sh":
    ensure => present,
    path => $export_rsacli_sh,
    # use ' to make escape puppet interpretation
    content => "#!/bin/sh

RSACLI_DIST=$rsa_src/cmdclient/dist/rsacli
export PATH=$RSACLI_DIST:$PATH
export LD_LIBRARY_PATH=$RSACLI_DIST/lib:$LD_LIBRARY_PATH
",
    mode => 755,
  }

}
