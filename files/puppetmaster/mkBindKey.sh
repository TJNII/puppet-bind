#!/bin/bash
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