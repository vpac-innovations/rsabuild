
class tomcat {

  $tomcat_port='8080'
  $tomcat_password='password'

  package{ [ 'tomcat6' ]:
    ensure => installed,
  }
->
  package{ [ 'tomcat6-admin-webapps' ]:
    ensure => installed,
  }
->
  file{ "/usr/share/tomcat6/conf/tomcat-users.xml":
    ensure => present,
    source => "puppet:///modules/tomcat/tomcat-users.xml.SAMPLE",
    owner => 'root',
  }
->
  file_line{ [ 'javaopts' ]:
    path => "/etc/tomcat6/tomcat6.conf",
    match => "^JAVA_OPTS=",
    line => 'JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote -XX:MaxPermSize=256M -Xmx8192m -Xms1024m -server -Djava.awt.headless=true"

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export CLASSPATH=/usr/local/lib/gdal.jar
',
  }
#->
#  service{ [ 'tomcat6' ]:
#    ensure => running,
#    hasstatus => true,
#    hasrestart => true,
#    require => Package['tomcat6'],
#  }

}

define tomcat::deployment($path) {

  include tomcat
  notice("Establishing http://$hostname:${tomcat::tomcat_port}/$name/")

  file { "/var/lib/tomcat6/webapps/${name}.war":
    owner => 'root',
    source => $path,
  }
->
  service{ [ 'tomcat6' ]:
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Package['tomcat6'],
  }

}

