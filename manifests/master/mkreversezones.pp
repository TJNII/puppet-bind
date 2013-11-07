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
class bind::master::mkreversezones (
  $admin,
  $master_hostname,
  $myNotify,
  $viewname,
  ) {
  bind::master::reversezone { "10. reverse zone":
    zone        => "10.in-addr.arpa",
    tgt_network => "10.0.0.0",
    tgt_netmask => "255.0.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }

  bind::master::reversezone { "192.168 reverse zone":
    zone        => "168.192.in-addr.arpa",
    tgt_network => "192.168.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }

  bind::master::reversezone { "172.16 reverse zone":
    zone        => "16.172.in-addr.arpa",
    tgt_network => "172.16.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.17 reverse zone":
    zone        => "17.172.in-addr.arpa",
    tgt_network => "172.17.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.18 reverse zone":
    zone        => "18.172.in-addr.arpa",
    tgt_network => "172.18.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.19 reverse zone":
    zone        => "19.172.in-addr.arpa",
    tgt_network => "172.19.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.20 reverse zone":
    zone        => "20.172.in-addr.arpa",
    tgt_network => "172.20.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.21 reverse zone":
    zone        => "21.172.in-addr.arpa",
    tgt_network => "172.21.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.22 reverse zone":
    zone        => "22.172.in-addr.arpa",
    tgt_network => "172.22.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.23 reverse zone":
    zone        => "23.172.in-addr.arpa",
    tgt_network => "172.23.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.24 reverse zone":
    zone        => "24.172.in-addr.arpa",
    tgt_network => "172.24.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.25 reverse zone":
    zone        => "25.172.in-addr.arpa",
    tgt_network => "172.25.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.26 reverse zone":
    zone        => "26.172.in-addr.arpa",
    tgt_network => "172.26.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.27 reverse zone":
    zone        => "27.172.in-addr.arpa",
    tgt_network => "172.27.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.28 reverse zone":
    zone        => "28.172.in-addr.arpa",
    tgt_network => "172.28.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.29 reverse zone":
    zone        => "29.172.in-addr.arpa",
    tgt_network => "172.29.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.30 reverse zone":
    zone        => "30.172.in-addr.arpa",
    tgt_network => "172.30.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
  bind::master::reversezone { "172.31 reverse zone":
    zone        => "31.172.in-addr.arpa",
    tgt_network => "172.31.0.0",
    tgt_netmask => "255.255.0.0",
    admin       => $admin,
    master_hostname => $master_hostname,
    myNotify    => $myNotify,
    viewname    => $viewname,
  }
  
}
