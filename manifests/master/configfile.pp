define bind::master::configfile (
  $viewname,
  $listen_port,
  $nrdc_port,
  $zonenames,
  $conf_file,
  $default_file,
  $pid_file,
  $master_hostname,
  $include_internal_zones = false,
  ) {

    # Reap keys from the slaves
    File <<| tag == "bind_slave_key_config" |>> {
      require => File["/etc/bind/keys"],
    }

    file { "$conf_file":
      ensure  => file,
      owner   => root,
      group   => bind,
      mode    => 644,
      content => template("bind/master/named.conf.erb"),
    }

    file { "$default_file" :
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => 644,
      content => template("bind/master/default.erb"),
    }

}
