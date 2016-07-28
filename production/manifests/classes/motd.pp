class motd {
    $motd = '/etc/motd'

      concat { $motd:
            owner        => 'root',
                group    => 'root',
                    mode => '0644'
                      }

                        concat::fragment{ 'motd_header':
                              target        => $motd,
                                  content   => "\nPuppet modules on this server:\n\n",
                                      order => '01'
                                        }

                                          # let local users add to the motd by creating a file called
                                            # /etc/motd.local
                                              concat::fragment{ 'motd_local':
                                                    target        => $motd,
                                                        source    => '/etc/motd.local',
                                                            order => '15'
                                                              }
}

# let other modules register themselves in the motd
define motd::register($content="", $order='10') {
    if $content == "" {
          $body = $name
            } else {
                  $body = $content
                    }

                      concat::fragment{ "motd_fragment_$name":
                            target          => '/etc/motd',
                                order       => $order,
                                    content => "    -- $body\n"
                                      }
}
