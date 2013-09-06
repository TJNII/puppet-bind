# my_slave_hostname: Hostname used in keys and NS records
# my_slave_resource_hostname: Hostname used when querying API for resources ($fqdn)
class bind::slave::coreservice (
  $master,
  $my_slave_hostname = $fqdn,
  $my_slave_resource_hostname = $fqdn,
  $manage_firewall = true,
  ) {
  
    include 'bind::slave::common'
    
    $slave_hostname = inline_template("<%= my_slave_hostname.downcase -%>")
    $slave_resource_hostname = inline_template("<%= my_slave_resource_hostname.downcase -%>")
    
    file { "/etc/bind/named.conf":
      owner   => root,
      group   => bind,
      mode    => 644,
      content => template("bind/slave/named.conf.erb"),
    }
    
    file { "/etc/bind/db.root":
      owner   => root,
      group   => bind,
      mode    => 644,
      source  => "puppet:///modules/bind/zones/dummy/db.root"
    }
    
    service { "bind9":
      ensure     => running,
      enable     => true,
      # Use stop and start, not restart
      hasrestart => false,
      subscribe  => [File["/etc/bind/named.conf"],
                     File["/etc/bind/keys"],
                     ],
      require    => [ File["/etc/bind/rndc.key"],
                      File["/etc/bind/db.root"],
                      ],
      
    }
    
    if $manage_firewall == true {
      include firewall-config::base
      
      firewall { "100 allow dns:53/udp":
        state => ['NEW'],
        dport => 53,
        proto => 'udp',
        action => accept,
      }
      
      firewall { "100 allow dns:53/tcp":
        state => ['NEW'],
        dport => 53,
        proto => 'tcp',
        action => accept,
      }
    }
}
