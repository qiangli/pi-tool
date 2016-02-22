import sys
import os
import subprocess
import json

def unmount(mount):
	cmd = "sudo umount " + mount
	
	print "cmd: " + cmd
	subprocess.call([cmd], shell=True)  
  
from pprint import pprint


desc=sys.argv[1]
mp=sys.argv[2]

print "Decriptor: " + desc
print "Mount point: " +  mp

with open(desc) as file:    
	data = json.load(file)
pprint(data)

for p in reversed(data['partitions']):
	unmount(mp + ('' if p['file'] == '/' else p['file']))

print "Done"
