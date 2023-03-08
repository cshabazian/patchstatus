#!/bin/sh
SECURITY=/tmp/security_updates
UPDATES=/tmp/rpmupdates
ALLUPDATES=/tmp/allupdates
LASTCHECKED=/tmp/lastchecked

# Get just the security updates:
yum update --security --assumeno 2> /dev/null | tail -n +6 | head -n -7 | egrep -v '(Installing|Upgrading)' | awk '{print $1","$3}' > $SECURITY

# Now get all of the updates:
yum update --assumeno 2> /dev/null | tail -n +6 | head -n -7 | egrep -v '(Installing|Upgrading)' | awk '{print $1","$3}' > $UPDATES

# Remove the security updates from the all updates file:
grep -vxFf $SECURITY $UPDATES > $ALLUPDATES

# Add "Update" to the files that need updating:
sed -i "s/^/update,/" $ALLUPDATES

# Add "Security" to the files that are security related:
sed -i "s/^/security,/" $SECURITY

# Combine the two files into one:
cat $SECURITY >> $ALLUPDATES

# Create a Last Checked file
ls -hal /tmp/allupdates | awk '{print $6," ",$7," ",$8}' > $LASTCHECKED

# Remove $SECURITY and $UPDATES
rm -f $UPDATES $SECURITY
