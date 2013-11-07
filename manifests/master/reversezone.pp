# Copyright 2013 Tom Noonan II (TJNII)
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
define bind::master::reversezone (
  $zone,
  $tgt_network,
  $tgt_netmask,
  $admin,
  $master_hostname,
  $myNotify,
  $viewname,
  ) {
    $serialfile = "/etc/bind/serials/$zone.serial"
    
    # Increment block to recieve notifies
    exec { "increment $viewname $zone serial":
      command     => "/usr/local/bin/bind/incrementSerial.py $serialfile",
      cwd         => "/etc/bind/serials",
      refreshonly => true,
    }
              
    
    # Pull in the static zone data
#    file { "/etc/bind/zones/reverse_zones/$viewname":
#      ensure  => directory,
#      owner   => root,
#      group   => bind,
#      mode    => 644,
#      source  => "puppet:///modules/bind/zones/reverse_zones/$viewname",
#      recurse => true,
#      purge   => true,
#      force   => true,
#      notify  => Exec["increment $viewname $zonefile serial"],
#    }

    # Include the dynamic data
    file { "/etc/bind/zones/reverse_zones/$viewname.dynamic.$zone.db":
      ensure  => file,
      group   => bind,
      mode    => 644,
      content => template("bind/master/reverse_dynamic.db.erb"),
      notify  => Exec["increment $viewname $zone serial"],
    }
    
    # Build the ns db file
    $nsdbfile = "/etc/bind/maindb/ns.$viewname.$zone.db"
    file { "$nsdbfile":
      ensure  => file,
      group   => bind,
      mode    => 644,
      content => template("bind/master/ns.db.erb"),
      notify  => Exec["increment $viewname $zone serial"],
    }
    
    # Build the main db file
    # This must not notify the serial incrementer as that will create an
    # endless template update -> serial increment -> template update loop
    # The included file notifies should be sufficient.
    file { "/etc/bind/maindb/$viewname.$zone.db":
      ensure  => file,
      group   => bind,
      mode    => 644,
      notify  => $myNotify,
      content => template("bind/master/reverse_master.db.erb"),
    }

}
