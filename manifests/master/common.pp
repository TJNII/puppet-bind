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
class bind::master::common (
  $manage_firewall = true,
  ) {

    # Package base
    package { 'bind':
      ensure => 'present',
      name   => 'bind9',
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
            "/etc/bind/keys"]:
      ensure  => directory,
      owner   => root,
      group   => bind,
      mode    => 644,
      recurse => true,
      purge   => true,
      force   => true,
    }

    file { [ "/etc/bind/serials",
             "/etc/bind/zones",
             "/etc/bind/zones/forward_zones/",
             "/etc/bind/zones/reverse_zones/",
             "/etc/bind/maindb", ]:
               ensure  => directory,
               owner   => root,
               group   => bind,
               mode    => 644,
    }

    # Dummy zones
    # (empty, 127, root, etc...)
    file { "/etc/bind/zones/dummy":
      ensure  => directory,
      owner   => root,
      group   => bind,
      mode    => 640,
      source  => "puppet:///modules/bind/zones/dummy",
      recurse => true,
      purge   => true,
      force   => true,
    }
    
    file { "/etc/bind/zones/forward_common":
      ensure  => directory,
      owner   => root,
      group   => bind,
      mode    => 640,
      source  => "puppet:///modules/bind/zones/forward_common",
      recurse => true,
      purge   => true,
      force   => true,
    }

    file { "/etc/bind/rndc.key":
      ensure  => file,
      owner   => bind,
      group   => bind,
      mode    => 640,
      source  => "puppet:///modules/bind/master/rndc.key"
    }

    # Install serial incrementer
    file { "/usr/local/bin/bind":
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => 755,
    }
    
    file { "/usr/local/bin/bind/incrementSerial.py":
      ensure => file,
      owner   => root,
      group   => root,
      mode    => 755,
      source  => "puppet:///modules/bind/master/incrementSerial.py",
    }

    # Custom init script
    file { "/etc/init.d/bind9_custom":
      ensure => file,
      owner   => root,
      group   => root,
      mode    => 755,
      source  => "puppet:///modules/bind/master/bind9_custom",
    }
              
}
