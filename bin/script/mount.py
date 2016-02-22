import sys
import os
import subprocess
import json

def mount(mount, img,sector, size):
	cmd = "sudo mount -t auto -o loop,user,group,offset=$(("+sector+"*"+size+")) "+img+" "+mount
	
	print "cmd: " + cmd
	if os.path.exists(mount):
		subprocess.call([cmd], shell=True)  
	else:
		print "Mount point does not exist"
		exit(-1)
  
from pprint import pprint

img=sys.argv[1]
desc=sys.argv[2]
mp=sys.argv[3]

print "Image: " + img
print "Decriptor: " + desc
print "Mount point: " +  mp

with open(desc) as file:    
	data = json.load(file)
pprint(data)

for p in data['partitions']:
	mount(mp+p['file'], img, p['sector'], p['size'])

print "Done"
