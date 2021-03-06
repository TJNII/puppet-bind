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
define bind::master::forwardzone (
  $viewname,
  $dynamic_identifier = undef,
  $zone,
  $admin,
  $master_hostname,
  ) {
    $serialfile = "/etc/bind/serials/$viewname.serial"
    
    # Increment block to recieve notifies
    exec { "increment $zone $viewname serial":
      command     => "/usr/local/bin/bind/incrementSerial.py $serialfile",
      cwd         => "/etc/bind/serials",
      refreshonly => true,
      subscribe   => File["/etc/bind/zones/forward_common"],
    }

    # Pull in the static zone data
    file { "/etc/bind/zones/forward_zones/$viewname":
      ensure  => directory,
      owner   => root,
      group   => bind,
      mode    => 644,
      source  => "puppet:///modules/bind/zones/forward_zones/$viewname",
      recurse => true,
      purge   => true,
      force   => true,
      notify  => Exec["increment $zone $viewname serial"],
    }

    # Include the dynamic data (If needed)
    if $dynamic_identifier != undef {
      file { "/etc/bind/zones/forward_zones/$viewname/dynamic.$viewname.db":
        ensure  => file,
        group   => bind,
        mode    => 644,
        content => template("bind/master/forward_dynamic.db.erb"),
        notify  => Exec["increment $zone $viewname serial"],
      }

      $dynamic_identifier_active = true
    } else {
      $dynamic_identifier_active = false
    }

    # Build the ns db file
    $nsdbfile = "/etc/bind/maindb/ns.$viewname.db"
    file { "$nsdbfile":
      ensure  => file,
      group   => bind,
      mode    => 644,
      content => template("bind/master/ns.db.erb"),
      notify  => Exec["increment $zone $viewname serial"],
    }
    
    # Build the main db file
    # This must not notify the serial incrementer as that will create an
    # endless template update -> serial increment -> template update loop
    # The included file notifies should be sufficient.
    file { "/etc/bind/maindb/$viewname.db":
      ensure  => file,
      group   => bind,
      mode    => 644,
      content => template("bind/master/forward_master.db.erb"),
    }

}
