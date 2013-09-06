class bind::puppetmaster {

  package { 'bind9utils':
    ensure => 'present',
  }

  # Generate spool directory for files
  file { [ "/var/spool/puppet",
           "/var/spool/puppet/remote" ]:
             ensure  => directory,
             owner   => puppet,
             group   => puppet,
  }

  file { [ "/var/spool/puppet/remote/bind",
           "/var/spool/puppet/remote/bind/bin",
           "/var/spool/puppet/remote/bind/keys" ]:
             ensure  => directory,
             owner   => puppet,
             group   => puppet,
             mode    => 640,
             recurse => true,
             purge   => true,
             force   => true,
  }

  # TSIG key generation script
  file { "/var/spool/puppet/remote/bind/bin/mkBindKey.sh":
    ensure  => directory,
    owner   => puppet,
    group   => puppet,
    mode    => 750,
    source  => "puppet:///modules/bind/puppetmaster/mkBindKey.sh",
  }


  # Reap keys
  File <<| tag == "bind_slave_key_puppetmaster_file" |>> {
    require => File["/var/spool/puppet/remote/bind/keys"],
  }
  
  Exec <<| tag == "bind_slave_key_puppetmaster_exec" |>> {
    require => [File["/var/spool/puppet/remote/bind/keys"],
                File["/var/spool/puppet/remote/bind/bin/mkBindKey.sh"]],
  }
  
}
