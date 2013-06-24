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
