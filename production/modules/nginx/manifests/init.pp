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
                  #@@file_fregment { "uniqe_name_lb${::fqdn}":
                  #content => "upstream cluster { \n",
                  #order   => 0,
                  #tag     => 'lb'
                  #}

                  @@file_fragment { "uniqe_name_l${::fqdn}":
                             content => "upstream cluster { \n",
                              tag    => 'web',
                               order => 0,
                  }

                  @@file_fragment { "uniqe_name_lo${::fqdn}":
                          content   => "}",
                          tag     => 'web',
                          order => 10,
                        }

          File_fragment <<| tag == 'web' |>>

           file_concat { '/etc/nginx/conf.d/up.conf':
                     tag   => 'web', # Mandatory
            }
            #file_concat { '/etc/nginx/conf.d/up.conf':
            #  tag   => 'lb',
            #}
}
