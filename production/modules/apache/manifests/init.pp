class apache {
    exec { 'apt-update':
          command => '/usr/bin/apt-get update'
            }
     package { 'apache2':
                    require => Exec['apt-update'],
                     ensure => present,
               }

      service { 'apache2':
                  ensure => running,
                  require => Package['apache2'],
              }

      file { '/var/www/html/index.html':
                content => "<h1> hello </h1>",
                 require => Package['apache2'],
      }
      # file { '/home/vagrant/test.txt':
      #         content => template('apache/temp.txt.erb'),
      #}
      #@@file { "/etc/nginx/conf.d/${::hostname}.conf" :
      #         path => "/etc/nginx/conf.d/${::hostname}.conf",
      #         content => "${::ipaddress_eth1}\n",
      #         tag => 'web_server',
      #         ensure => file,
      # }
    @@file_fragment { "uniqe_name_${::fqdn}":
      content => "server  ${::ipaddress_eth1};\n",
      tag     => 'web',
    }
    File_fragment <<| tag == 'web' |>>
    file_concat { '/tmp/test.txt':
     tag     => 'web', # Mandatory
     replace => true
    }
    # file { '/home/vagrant/test.txt':
    #                  content => template('apache/testi.txt.erb'),
    #   }
    #motd::register{ 'Apache': }
}
