import json
import pprint
import subprocess
import sys


def unmount(mp):
    cmd = "sudo umount " + mp

    print "cmd: " + cmd
    return subprocess.call([cmd], shell=True)


desc = sys.argv[1]
mountpoint = sys.argv[2]

print "Decriptor: " + desc
print "Mount point: " + mountpoint

with open(desc) as file:
    data = json.load(file)
#pprint.pprint(data)

for p in reversed(data['partition']):
    rc = unmount(mountpoint + ('' if p['file'] == '/' else p['file']))
    if rc != 0:
        exit(1)

print "Done"
exit(0)
