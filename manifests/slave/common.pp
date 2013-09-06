class bind::slave::common {
  
    # Package base
    package { 'bind':
      ensure => 'present',
      name   => 'bind9'
    }

    # User/group
    group { 'bind':
      ensure => 'present',
      require => Package["bind"],
      system => true,
    }
    
    user { 'bind':
      shell => '/bin/false',
      groups => ['bind'],
      ensure => 'present',
      require => Group["bind"],
      system => true,
    }
    
    
    # Create configuration tree
    # Purge the tree base
    file { ["/etc/bind",
            "/etc/bind/conf.d",
            "/etc/bind/keys"]:
      ensure  => directory,
      owner   => root,
      group   => bind,
      mode    => 644,
      recurse => true,
      purge   => true,
      force   => true,
    }

    file { "/var/lib/bind":
      owner   => bind,
      group   => bind,
      mode    => 775,
    }

    file { "/etc/bind/rndc.key":
      ensure  => file,
      owner   => bind,
      group   => bind,
      mode    => 640,
      require => Exec["Generate RNDC key"],
    }

    package { 'bind9utils':
      ensure => 'present',
    }

    exec { "Generate RNDC key":
      command     => "/usr/sbin/rndc-confgen -a -k /etc/bind/rndc.key -u bind",
      cwd         => "/etc/bind",
      refreshonly => true,
      require     => [ Package["bind9utils"],
                       User["bind"],
                       File["/etc/bind"], ],
    }      
      
              
}
