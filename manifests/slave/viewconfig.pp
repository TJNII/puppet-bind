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
    
