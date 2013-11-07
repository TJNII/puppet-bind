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
