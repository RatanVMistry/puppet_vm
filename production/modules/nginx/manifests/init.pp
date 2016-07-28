class nginx{

    exec { 'apt-update':
          command => '/usr/bin/apt-get update'
        }

        package { 'nginx':
              require  => Exec['apt-update'],
               ensure => present,
              }

              file { '/etc/nginx/nginx.conf' :
                content => template('nginx/nginx.conf.erb')
              
              }
        service { 'nginx':
                      ensure => running,
                      require => Package['nginx'],
                  }
                  # File <<| tag == 'web_server' |>>
          File_fragment <<| tag == 'web' |>>
           file_concat { '/etc/nginx/conf.d/up.conf':
                     tag => 'web', # Mandatory
            }
}
