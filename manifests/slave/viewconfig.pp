define bind::slave::viewconfig (
  $viewname,
  $priority,
  $master,
  $master_port,
  $zonenames,
  $include_internal_zones,
  $allow_recursion,
  $acls,
  $my_slave_hostname = $fqdn,
  $my_slave_resource_hostname = $fqdn,
  $tsig_key_retention = "3 months"
  ) {
    include 'bind::slave::common'
    include 'bind::slave::coreservice'

    $slave_hostname = inline_template("<%= my_slave_hostname.downcase -%>")
    $slave_resource_hostname = inline_template("<%= my_slave_resource_hostname.downcase -%>")
    
    # Generate and export key
    bind::slave::exportkey { "$hostname $viewname tsig key":
      slave_hostname => $slave_hostname,
      view           => $viewname,
      retention      => $tsig_key_retention,
    }
          
    # Create zone config
    file { "/etc/bind/conf.d/$priority-$viewname.conf":
      ensure  => file,
      owner   => root,
      group   => bind,
      mode    => 644,
      content => template("bind/slave/view.conf.erb"),
      notify  => Service["bind9"],
    }
}
    
