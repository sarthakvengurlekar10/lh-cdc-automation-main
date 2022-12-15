__version__ = '1.0.0'

import os
import re

class Volume(object):
  ROBOT_LIBRARY_VERSION = __version__
  ROBOT_LIBRARY_SCOPE = 'GLOBAL'
  YAML_DIR = "yamls"
  HOSTER_ID_TAG = "${HOSTER_ID}"
  PORTAL_ID_TAG = "${PORTAL_ID}"
  VOL_ID_TAG = "${VOL_ID}"
  VOL_NAME_TAG = "${VOL_NAME}"
  VOL_FLAVOR_ID_TAG = "${VOL_FLAVOR_ID}"
  POD_ID_TAG = "${POD_ID}"
  CAPACITY_TAG = "${CAPACITY}"
  COUNTRY_TAG = "${COUNTRY}"
  REGION_TAG = "${REGION}"
  DATA_CENTER_TAG = "${DATA_CENTER}"
  VOL_YAML_TEMPLATE = "volume.yml.tmpl"


  def list_volume(self):
    stream = os.popen("./qctl volumes list")
    output = stream.readlines()
    if len(output) < 3:
       return []

    volume_ids = []
    for line in output[2:]:
        match = re.search(r"\w+-\w+-\w+-\w+-\w+", line)
        if match is None:
          continue
        volume_ids.append(match.group(0))

    return volume_ids


  def create_volume_yaml(self, volume_id, volume_name, flavor_id, pod_id, location, capacity, volume_yaml):
    template_file = os.path.join(self.YAML_DIR, self.VOL_YAML_TEMPLATE)
    print(template_file)
    f = open(template_file, "r+")
    yml = f.read()
    f.close()

    yml = yml.replace(self.VOL_ID_TAG, volume_id)
    yml = yml.replace(self.VOL_NAME_TAG, volume_name)
    yml = yml.replace(self.VOL_FLAVOR_ID_TAG, flavor_id)
    yml = yml.replace(self.POD_ID_TAG, pod_id)
    yml = yml.replace(self.CAPACITY_TAG, capacity)
    yml = yml.replace(self.COUNTRY_TAG, location["country"])
    yml = yml.replace(self.REGION_TAG, location["region"])
    yml = yml.replace(self.DATA_CENTER_TAG, location["data_center"])
    print(yml)
    
    file = os.path.join(self.YAML_DIR, volume_yaml)
    with open(file, "w+") as f:
      f.write(yml)
 

  def create_volume(self, yaml_file):
    file = os.path.join(self.YAML_DIR, yaml_file)
    cmd = "./qctl volumes create -f %s"%(file)
    stream = os.popen(cmd)
    output = stream.read()
    print(output)
    if "error" in output:
      return False, output

    return True, output


  def delete_volume(self, volume_id):
    cmd = "./qctl volumes delete %s"%(volume_id)
    stream = os.popen(cmd)
    output = stream.read()
    print(output)
    if "error" in output:
      return False, output

    return True, output


  def check_volume_status(self, volume_id):
    cmd = "./qctl volumes get %s"%(volume_id)
    stream = os.popen(cmd)
    output = stream.read()
    print(output)
    match_state = re.search(r"state:\s+allocated", output)
    
    if match_state:
      return True, output

    return False, output




