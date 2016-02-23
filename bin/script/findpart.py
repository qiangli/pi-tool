#
# find resize partition in descriptor file
# return partition_number sector
#
import json
import sys

if len(sys.argv) != 2:
    print "Descriptor file required"
    exit(1)

desc = sys.argv[1]

with open(desc) as descfile:
    data = json.load(descfile)

for p in data['partition']:
    if p['resize'] == 'y':
        print p['number'] + ' ' + p['sector']
        exit(0)

print 'Resizeable partition not defined'
exit(1)
##
