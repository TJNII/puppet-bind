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
class bind::puppetmaster {

  package { 'bind9utils':
    ensure => 'present',
  }

  # Generate spool directory for files
  file { [ "/var/spool/puppet",
           "/var/spool/puppet/remote" ]:
             ensure  => directory,
             owner   => puppet,
             group   => puppet,
  }

  file { [ "/var/spool/puppet/remote/bind",
           "/var/spool/puppet/remote/bind/bin",
           "/var/spool/puppet/remote/bind/keys" ]:
             ensure  => directory,
             owner   => puppet,
             group   => puppet,
             mode    => 640,
             recurse => true,
             purge   => true,
             force   => true,
  }

  # TSIG key generation script
  file { "/var/spool/puppet/remote/bind/bin/mkBindKey.sh":
    ensure  => directory,
    owner   => puppet,
    group   => puppet,
    mode    => 750,
    source  => "puppet:///modules/bind/puppetmaster/mkBindKey.sh",
  }


  # Reap keys
  File <<| tag == "bind_slave_key_puppetmaster_file" |>> {
    require => File["/var/spool/puppet/remote/bind/keys"],
  }
  
  Exec <<| tag == "bind_slave_key_puppetmaster_exec" |>> {
    require => [File["/var/spool/puppet/remote/bind/keys"],
                File["/var/spool/puppet/remote/bind/bin/mkBindKey.sh"]],
  }
  
}
