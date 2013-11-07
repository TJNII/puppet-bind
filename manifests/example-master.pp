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
# example-master.pp: Example master.pp file for the bind::master class
# to configure the bind master server.
# Currently contains site specific data.
class bind::master {
  # Master service for the internal service: Internal bind view
  # for internal hosts
  bind::master::service { "example.com internal service":
    # The name of this view
    # This needs to match files/zones/forward_zones/${viewname}/
    viewname           => "internal",
    # The identifier used by the ipclassifier commonfacts module
    # Used for automatic zone generation
    dynamic_identifier => "internal",
    # The domain name for this zone
    zone               => "example.com",
    # The listen port for this bind instance
    # Must be unique, and is used by the slaves
    # Otherwise arbitrary.
    listen_port            => 1254,
    # NRDC listen port, used internally.
    # Must be unique, otherwise arbitrary.
    nrdc_port              => 1354,
    # Include internal only zones such as records for loopback,
    # RFC1918 private networks, and 0.0.0.0.
    include_internal_zones => true,
  }

  # Master service for the external service: External bind view
  # visible on the public internet.
  # See internal block for argument description
  bind::master::service { "example.com external service":
    viewname           => "external",
    dynamic_identifier => "public",
    zone               => "example.com",
    listen_port            => 1253,
    nrdc_port              => 1353,
    include_internal_zones => false,
  }

  # Ensure the base bind9 service is stopped.
  # (Shouldn't run due to missing conf file.)
  # This is just to be safe, the services above use custom service names.
  service { "bind9":
    ensure    => stopped,
  }    
          
}
