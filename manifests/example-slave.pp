# example-slave.pp: Example slave.pp file for the bind::slave class
# to configure the bind slave servers.
# Currently contains site specific data.
class bind::slave (
  # When true classes will use puppetlabs-firewall to open ports
  $manage_firewall = true,
  # The hostname of the slave
  $slave_hostname  = $fqdn,
  # THe hostname of the master
  $master          = "masns1.example.com"
  ) {

    # This class configures the core of the module and needs to be called once.
    class { "bind::slave::coreservice":
      master            => $master,
      manage_firewall   => $manage_firewall,
      my_slave_hostname => $slave_hostname,
    }

    # Configure the internal view to be served to clients coming from an internal IP
    bind::slave::viewconfig { "EXAMPLE.com Slave internal view":
      # The name of this view, should match the master
      viewname    => "internal",
      # The more permissive the ACL the higher the priority value to ensure
      #   proper ordering.
      priority    => 10,
      # Master server FQDN
      master      => $master,
      # Master port for this view, must match the port configured in the master.pp
      #  view config block
      master_port => 1254,
      # Domain names for this view
      zonenames   => [ "example.com" ],
      # Include internal only records like 127.0.0.0, RFC1918 addresses, etc.
      include_internal_zones => true,
      # Allow recursion: Return records for domains we are not authorative for.
      # This should be true for your internal views, and MUST be false for public views.
      allow_recursion        => true,
      # Access control lists for this view.  Here we allow the RFC1918 private address space.
      acls        => [ "10.0.0.0/8",
                       "10.128.0.0/24",
                       "192.168.0.0/16" ],
      # The hostname of this server.
      my_slave_hostname => $slave_hostname,
    }

    # Public view for all hosts
    # See internal view for descriptions
    bind::slave::viewconfig { "EXAMPLE.com Slave external view":
      viewname    => "external",
      priority    => 20,
      master      => $master,
      master_port => 1253,
      zonenames   => [ "example.com" ],
      include_internal_zones => false,
      # Again, with an ACL of any allow_recursion must be false
      # Otherwise your server can be leveraged in DNS amplification
      # DDOS attacks.
      allow_recursion        => false,
      acls        => [ "any" ],
      my_slave_hostname => $slave_hostname,
    }
  }
