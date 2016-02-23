#
# convert descriptor json to map
#
import json
import sys

#
desc = sys.argv[1]

with open(desc) as descfile:
    jsondata = json.load(descfile)


#
def flatten(data, key=None):
    if isinstance(data, (list, tuple)):
        for i, e in enumerate(data):
            flatten(e, key=key + "_" + str(i))
    elif isinstance(data, dict):
        for k in data:
            flatten(data[k], key=k if key is None else "_".join([key, k]))
    else:
        print 'DESCRIPTOR["' + key + '"]="' + data + '"'


#
print "#" + desc
print "declare -A DESCRIPTOR"

flatten(jsondata)

##
