# Currently only supports one zone.
define bind::master::service (
  $viewname,
  $zone,
  $listen_port,
  $nrdc_port,
  $admin = undef,
  $dynamic_identifier = undef,
  $include_internal_zones = false,
  $manage_firewall = true,
  $my_master_hostname = $fqdn,
  ) {

    include 'bind::master::common'

    $conf_file      = "/etc/bind/named.$viewname.conf"
    $default_file   = "/etc/default/bind9.$viewname"
    $pid_file       = "/var/run/named/named.$viewname.pid"
    $master_hostname = inline_template("<%= my_master_hostname.downcase -%>")

    if $admin == undef {
      $myAdmin = "root@$zone"
    } else {
      $myAdmin = $admin
    }

    if $include_internal_zones == true {
      class { 'bind::master::mkreversezones':
        admin       => $myAdmin,
        master_hostname => $master_hostname,
        myNotify    => Service["bind9_$viewname"],
        viewname    => $viewname,
      }
    }

    bind::master::forwardzone { "bind9 $zone $viewname db":
      viewname           => $viewname,
      dynamic_identifier => $dynamic_identifier,
      zone               => $zone,
      admin              => $myAdmin,
      master_hostname    => $master_hostname,
    }
    
    bind::master::configfile { "bind9 $zone $viewname conf":
      viewname               => $viewname,
      listen_port            => $listen_port,
      nrdc_port              => $nrdc_port,
      zonenames              => { "$viewname" => "$zone" },
      include_internal_zones => $include_internal_zones,
      conf_file              => $conf_file,
      default_file           => $default_file,
      pid_file               => $pid_file,
      master_hostname    => $master_hostname,
    }

    file { "/etc/init.d/bind9_$viewname":
      ensure => file,
      owner   => root,
      group   => root,
      mode    => 755,
      content  => template("bind/master/initscript.erb"),
    }
    
    # TODO: Use a template to create per-service init scripts
    service { "bind9_$viewname":
      ensure    => running,
      enable    => true,
      # Use stop and start, not restart
      hasrestart => false,
      
      subscribe => [File["$conf_file"],
                    File["/etc/bind/maindb/$viewname.db"],
                    File["/etc/bind/keys"],
                    ],
      require   => [ File["/etc/bind/rndc.key"],
                     File["/etc/init.d/bind9_$viewname"],
                     ],

      
    }

    if $manage_firewall == true {
      include firewall-config::base
      
      firewall { "100 allow dns:$listen_port/udp for $viewname view":
        state => ['NEW'],
        dport => $listen_port,
        proto => 'udp',
        iniface => "$interfaces_internal",
        action => accept,
      }
      firewall { "100 allow dns:$listen_port/tcp for $viewname view":
        state => ['NEW'],
        dport => $listen_port,
        proto => 'tcp',
        iniface => "$interfaces_internal",
        action => accept,
      }
    }
}
