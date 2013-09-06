#!/usr/bin/python -tt
# incrementSerial.py: Increment a Bind style serial stored in a dedicated file
# 18jun13 TJNII
import sys
import datetime
import syslog

# readSerial: Read the serial in from the data file
# PRE: None
# POST: None
# RETURN VALUE: old serial on success, False on failure
def readSerial(filename):
    try:
        with open(filename, 'r') as fd:
            fileData = fd.read()
    except IOError:
        syslog.syslog("%s: WARNING: Error opening file for reading." % sys.argv[0])
        return 0

    try:
        return int(fileData.strip())
    except ValueError:
        syslog.syslog("%s: ERROR: Error reading file data." % sys.argv[0])
        return False


# incrementSerial: Increment the serial
# PRE: oldSerial is an integer
# POST: None
# RETURN VALUE: new serial on success, False on failure
#
# FORMATTING: YYYYMMDDCC
# YYYY: 4 digit year
# MM: 2 digit month
# DD: 2 digit day
# CC: 2 digit counter
def increment(oldSerial):
    newDateCode = int(datetime.date.today().strftime("%Y%m%d"))

    if oldSerial < (newDateCode * 100):
        return (newDateCode * 100)
    
    if (oldSerial / 100) > newDateCode:
        syslog.syslog("%s: ERROR: Old date code is in the future!" % sys.argv[0])
        return False

    # oldSerial isn't older, and is not in the future.
    # Same day logic
    assert((oldSerial / 100) == newDateCode)

    if (oldSerial % 100) >= 99:
        syslog.syslog("%s: ERROR: Serial counter at maximum for today" % sys.argv[0])
        return False

    return (oldSerial + 1)

# writeSerial: Read the serial in from the data file
# PRE: None
# POST: None
# RETURN VALUE: True on success, False on failure
# Separate from read() for the intial case: where an open failure should not cause total failure
def writeSerial(newSerial, filename):
    try:
        with open(filename, 'w') as fd:
            fd.write(str(newSerial))
    except IOError:
        syslog.syslog("%s: ERROR: Error writing file." % sys.argv[0])
        return False

def main():
    if len(sys.argv) != 2:
        print 'usage: %s [target file]' % sys.argv[0]
        return 1

    syslog.syslog("%s: Incrementing %s" % (sys.argv[0], sys.argv[1]))
 
    oldSerial = readSerial(sys.argv[1])
    if oldSerial is False:
        return 1

    newSerial = increment(oldSerial)
    if newSerial is False:
        return 1

    syslog.syslog("%s: New serial: %d" % (sys.argv[0], newSerial))

    if writeSerial(newSerial, sys.argv[1]) is False:
        return 1

    return 0    

if __name__ == '__main__':
    sys.exit(main())
