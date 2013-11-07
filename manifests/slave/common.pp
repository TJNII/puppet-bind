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
class bind::slave::common {
  
    # Package base
    package { 'bind':
      ensure => 'present',
      name   => 'bind9'
    }

    # User/group
    group { 'bind':
      ensure => 'present',
      require => Package["bind"],
      system => true,
    }
    
    user { 'bind':
      shell => '/bin/false',
      groups => ['bind'],
      ensure => 'present',
      require => Group["bind"],
      system => true,
    }
    
    
    # Create configuration tree
    # Purge the tree base
    file { ["/etc/bind",
            "/etc/bind/conf.d",
            "/etc/bind/keys"]:
      ensure  => directory,
      owner   => root,
      group   => bind,
      mode    => 644,
      recurse => true,
      purge   => true,
      force   => true,
    }

    file { "/var/lib/bind":
      owner   => bind,
      group   => bind,
      mode    => 775,
    }

    file { "/etc/bind/rndc.key":
      ensure  => file,
      owner   => bind,
      group   => bind,
      mode    => 640,
      require => Exec["Generate RNDC key"],
    }

    package { 'bind9utils':
      ensure => 'present',
    }

    exec { "Generate RNDC key":
      command     => "/usr/sbin/rndc-confgen -a -k /etc/bind/rndc.key -u bind",
      cwd         => "/etc/bind",
      refreshonly => true,
      require     => [ Package["bind9utils"],
                       User["bind"],
                       File["/etc/bind"], ],
    }      
      
              
}
