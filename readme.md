Puppet-Bind
===========

OS Support
----------

Currently only tested on Debian.
May work in Ubuntu, expected to fail on RHEL.

Overview
--------

This is a module framework for managing multiple, distrubuted split-horizon
bind nameservers with puppet.  This module is not complete out-of-the-box and
does require further configuration for operation.  When fully configured this
module will build a DNS infrastructure that automatically advertises server
public IPs on the public internet and private IPs internally.

This module uses the ip classifier fact from commonfacts: https://github.com/TJNII/puppet-commonfacts

### Topology

The basic topology is a single master to multiple slaves configuration.
The master server hosts multiple bind instances, each on a custom port,
with one bind instance per slave view zone.
(Multiple master daemons are required for proper slave zone notifies.)
The master holds and distributes all zone files for all views.

When a update is created, Puppet will automatically update the db files
and reload the master bind process.  This will send a zone notify to all slaves,
who will automatically request a zone update.  The slaves are not restarted
under normal operation to maintain uptime.  If a bad update is pushed, the master
will fail to restart and the slaves will remain up with the previous zone data.

This module will automatically handle bind replication and will configure the
TSIG keys automatically.

This module does require a class to be installed on the puppetmaster.
This class is responsible for generation and aging of TSIG keys for slave replication.
The puppetmaster module creates a file tree in /var/spool/puppet which contains
the logic to generate the TSIG keys.  Key generation is handled on the puppetmaster
to easily and securely allow the keys to be shared with the bind master and slaves.

This module pupulates the automatic records from facter facts (via the commonfacts module)
stored in the puppetDB.  A client side module is not required!  A, AAAA, and PTR records
are automatically generated as appropriate.

Update Time
-----------

Currently the module requires two puppet runs on the nameserver master to propagate a
new record.  The change process is as follows:

* ---- RUN 1 ----
* Puppet changes a member db file to modify a record
* The db file change triggers exec of the serial script via puppet notify[]
* The serial incrementer script increments the source serial file on the filesystem

* ---- RUN 2 ----
* Puppet pulls in the new serial and updates the main db file
* The main db file change triggers a reload of the bind service for the view
* The DNS daemon for the view reloads and notifies the slaves of a zone change
* The slaves request new zone data from the master and update their files.

Site Specific Changes
---------------------

There are two types of site changes that are worked into this module:

### Custom zone files
For records that are not automatically generated this module supports inclusion of static
zone files.  The files should end in .db to be included.  The locations are as follows:

* files/zones/forward_common/: This directory contains db files that will be included in
all views.  This directory is intended to contain records common to all zones, like MX records,
SPF TXT records, and such.
* files/zones/forward_zones/${viewname}/: These directories contain the per-zone db files.
$viewname is defined in the master config files, see below.  These directories are (obviously)
unique per zone view.

### Config pp files
Currently there is no bind::master or bind::slave classes as they contain site-specific data
in the current revision.  See the example-master.pp and example-slave.pp manifest files for
details on this.

Example site config
-------------------

This assumes you have configured your master.pp and site.pp

    node "puppetmaster.example.com" {
      # bind glue class
      class { 'bind::puppetmaster': }
    }

    node "masns1.example.com" {
      class {'bind::master': }
    }
    
    node "ns1.example.com" {
      class {'bind::slave': }
    }
    
    node "ns2.example.com" {
      class {'bind::slave': }
    }

