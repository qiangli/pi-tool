#
#
#
import json
import os
import subprocess
import sys
import pprint


def mount(mp, img, sector, size):
    cmd = "sudo mount -t auto -o loop,user,group,offset=$((" + sector + "*" + size + ")) " + img + " " + mp

    print "cmd: " + cmd
    if os.path.exists(mp):
        return subprocess.call([cmd], shell=True)
    else:
        print "Mount point does not exist"
        exit(-1)


image = sys.argv[1]
desc = sys.argv[2]
mountpoint = sys.argv[3]

print "Image: " + image
print "Decriptor: " + desc
print "Mount point: " + mountpoint

with open(desc) as descfile:
    data = json.load(descfile)
#pprint.pprint(data)

for p in data['partition']:
    rc = mount(mountpoint + p['file'], image, p['sector'], p['size'])
    if rc != 0:
        exit(1)

print "Done"
exit(0)
