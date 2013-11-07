#!/bin/bash
#
# PUPPET MANAGED FILE: DO NOT EDIT
#

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
# mkBindKey: Generate a bind TSIG key
# $1: target hostname
# $2: output file
# $3: Regeneration age

if [ -z "$1" -o -z "$2" -o -z "$3" ]; then
    echo "ERROR: Invalid arguments" >&2
    exit 1
fi

# Verify file age
if [ -f "$2" ]; then
    # Verify file is valid
    if [ -n "`grep "^[^[:space:]]\+$" "$2"`" -a `cat "$2" | wc -l` -eq 1 ]; then
	    if [ $(date +%s -r "$2") -gt $(date +%s --date="$3 ago") ]; then
		exit 0
	    fi
    fi
fi


tmpdir=`mktemp -d`
if [ ! -d "$tmpdir" ]; then
    echo "ERROR: tmpdir creation failed" >&2
    exit 1
fi

if [ -z "`echo "$tmpdir" | grep "^/tmp/tmp"`" ]; then
    echo "ERROR: tmpdir creation failed" >&2
    exit 1
fi

out=`/usr/sbin/dnssec-keygen -K "$tmpdir" -a HMAC-MD5 -b 256 -n HOST "$1"`

if [ ! -f "$tmpdir/$out.private" ]; then
    echo "ERROR: key creation failed" >&2
    exit 1
fi

key=`grep "^Key:" "$tmpdir/$out.private" | awk '{print $2}'`

if [ -z "`echo "$key" | grep "^[^[:space:]]\+$"`" ]; then
    echo "ERROR: key parse failed" >&2
    exit 1
fi

rm -r "$tmpdir"

echo "$key" > $2
chmod 640 $2