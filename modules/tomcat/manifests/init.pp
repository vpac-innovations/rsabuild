
class tomcat {

  $tomcat_port='8080'
  $tomcat_password='password'

  notice("Establishing http://$hostname:$tomcat_port/")

      package{ [ 'tomcat6' ]:
               ensure => installed,
      }

      package{ [ 'tomcat6-admin-webapps' ]:
               ensure => installed,
               require => Package['tomcat6'],
      }

      service{ [ 'tomcat6' ]:
              ensure => running,
              #enable => true,
              #hasrestart => true,
              require => Package['tomcat6'],
      }

      file_line{ [ 'javaopts' ]:
              path => "/etc/tomcat6/tomcat6.conf",
              match => "^JAVA_OPTS=",
              line => "JAVA_OPTS=\"\$JAVA_OPTS -Dcom.sun.management.jmxremote -XX:MaxPermSize=256M -Xmx8192m -Xms1024m -server -Djava.awt.headless=true\"",
              notify => Service['tomcat6'],
              require => Package['tomcat6'],
      }

      file{ "/usr/share/tomcat6/conf/server.xml":
              ensure => present,
              source => "puppet:///modules/tomcat/server.xml.SAMPLE",
              owner => 'tomcat',
              group => 'tomcat',
              require => Package['tomcat6'],
              notify => Service['tomcat6'],
      }

      file{ "/usr/share/tomcat6/conf/tomcat-users.xml":
              ensure => present,
              source => "puppet:///modules/tomcat/tomcat-users.xml.SAMPLE",
              owner => 'tomcat',
              group => 'tomcat',
              require => Package['tomcat6'],
              notify => Service['tomcat6'],
      }

      file{ "/etc/tomcat6/tomcat6.conf":
              ensure => present,
              source => "puppet:///modules/tomcat/tomcat6.conf.SAMPLE",
              owner => 'tomcat',
              group => 'tomcat',
              require => Package['tomcat6'],
              notify => Service['tomcat6'],
      }

      file{ [ '/usr/share/tomcat6/webapps/manager/WEB-INF/web.xml' ]:
            ensure => present,
            owner => 'tomcat',
            group => 'tomcat',
            source => "puppet:///modules/tomcat/web.xml.SAMPLE",
            notify => Service[ "tomcat6" ],
            require => Package[ "tomcat6" ],
      }


}

define tomcat::deployment($path) {

  include tomcat
  notice("Establishing http://$hostname:${tomcat::tomcat_port}/$name/")

  file { "/var/lib/tomcat6/webapps/${name}.war":
    owner => 'root',
    source => $path,
  }
}

