#!/bin/sh

######################## SET THESE VARIABLES ########################
WEBHOST=
WEBDIR=
WEBFILE=
#####################################################################

if [[ -z "$WEBHOST" || -z "$WEBDIR" || -z "$WEBFILE" ]] ; then
        echo "One or more of the required variables in the makehtml.sh file are missing"
        exit
fi

UPDATETABLE=/tmp/updatetable
HTML=/tmp/results.html

rm -f $UPDATETABLE

for i in `ls /tmp/updates/` ; do 
UPDATES=`wc -l < /tmp/updates/$i/updates`
SECURITY=`grep security /tmp/updates/$i/updates | wc -l`
echo -n $i >> $UPDATETABLE
echo -n "," >> $UPDATETABLE
echo -n $UPDATES >> $UPDATETABLE
echo -n "," >> $UPDATETABLE
echo  -n $SECURITY >> $UPDATETABLE
echo -n "," >> $UPDATETABLE
# Remove the release name from the release file
sed -i 's/(.*//' /tmp/updates/$i/redhat-release
echo -n "$(</tmp/updates/$i/redhat-release)"  >> $UPDATETABLE
echo -n "," >> $UPDATETABLE
echo -n "$(</tmp/updates/$i/lastchecked)"  >> $UPDATETABLE
echo -n "," >> $UPDATETABLE
echo "$(</tmp/updates/$i/reboot)"  >> $UPDATETABLE
done

sed -i 's/,0,/,,/' $UPDATETABLE
sed -i 's/,0,/,,/' $UPDATETABLE
sed -i 's/ ,/,/' $UPDATETABLE

cat << EOF > $HTML
<center><br><br>
<style>
table, th, td {
  border: 2px solid black;
  border-collapse: collapse;
}
td {
    padding: 0 30px;
  }
</style>
<table>

<tr><td><h3><b><center>Hostname</td><td colspan="2"><h3><b><center>Updates</td><td><h3><b><center>Release</td><td><h3><b><center>Last Checked</td><td><h3><b><center>Reboot Required</td></tr>

EOF

awk -F , '{ print "<tr><td>" $1 "</td><td><font color=\"green\">" $2 "</td><td><font color=\"red\">" $3 "</td><td>" $4 "</td><td>" $5 "</td><td>" $6 "</td></tr>" }' $UPDATETABLE >> $HTML

cat << EOF >> $HTML

</table>
EOF

scp $HTML $WEBHOST:$WEBDIR/$WEBFILE
