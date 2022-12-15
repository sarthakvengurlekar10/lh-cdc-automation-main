__version__ = '1.0.0'

import os
import yaml

class Cluster(object):
  ROBOT_LIBRARY_VERSION = __version__
  ROBOT_LIBRARY_SCOPE = 'GLOBAL'
  YAML_DIR = "yamls"
  ARRAY_YAML_TEMPLATE = "array.yml.tmpl"
  HOSTER_ID_TAG = "${HOSTER_ID}"
  PORTAL_ID_TAG = "${PORTAL_ID}"
  RACK_ID_TAG = "${RACK_ID}"
  POD_ID_TAG = "${POD_ID}"
  ARRAY_ID_TAG = "${ARRAY_ID}"
  STORAGE_ID_TAG = "${STORAGE_ID}"
  ACS_TAG = "${ACS}"


  def login_portal(self, portal, user, password, membership, role):
    stream = os.popen("./qctl login --portal %s --user %s --password %s --membership %s --role %s"%(portal, user, password, membership, role))
    output = stream.read()
    if "Login successful" in output:
      return True, output

    return False, output 


  def list_arrays(self):
    stream = os.popen("./qctl arrays list")
    output = stream.readlines()
    if len(output) < 3:
       return []

    array_ids = []
    for line in output[2:]:
        parsed = line.split()
        if len(parsed) < 4:
          continue
        array_ids.append(parsed[1])

    return array_ids


  def list_racks(self):
    stream = os.popen("./qctl racks list")
    output = stream.readlines()
    return output


  def get_first_rack_id(self, output):
    if len(output) < 3:
      return ""
    parsed = output[2].split()
    if len(parsed) != 4:
      return ""

    return parsed[1]

  def list_pods(self):
    stream = os.popen("./qctl pods list")
    output = stream.readlines()
    return output


  def get_pod_id_by_name(self, name, output):
    if len(output) < 3:
      return ""

    for line in output[2:]:
        parsed = line.split()
        if len(parsed) < 4:
          continue
        if parsed[0].strip() == name:
            return parsed[1]

    return ""


  def get_pod_location(self, pod_id):
    stream = os.popen("./qctl pods get %s"%(pod_id))
    output = stream.read()
    yml = yaml.safe_load(output)
    print(yml)
    return yml["location"]


  def get_first_pod_id(self, output):
    if len(output) < 3:
      return ""
    parsed = output[2].split()
    if len(parsed) != 4:
      return ""

    return parsed[1]


  def list_capacity_pools(self):
    stream = os.popen("./qctl capacitypools list")
    output = stream.readlines()
    print(output)
    return output


  def find_capacity_pool_for_array(self, name, output):
    for line in output[2:]:
        parsed = line.split()
        if len(parsed) < 4:
          continue
        if name in parsed[0].strip():
            return parsed[1]

    return ""

 
  def list_hosters(self):
    stream = os.popen("./qctl hosters list")
    output = stream.readlines()
    return output

  def get_first_hoster_id(self, output):
    if len(output) < 3:
      return ""
    parsed = output[2].split()
    if len(parsed) != 4:
      return ""

    return parsed[1]


  def get_array_acs(self, cluster_user, cluster_pass, storage_rest_host, storage_id, cdc_rest_uri, cluster_type):
    return "\"username=%s;password=%s;storageRestHost=%s;storageId=%s;cdcRestUri=%s;clusterType=%s\""%(cluster_user, cluster_pass, storage_rest_host, storage_id, cdc_rest_uri, cluster_type) 

 
  def create_array_yaml(self, portal_id, hoster_id, rack_id, pod_id, acs, array_id, storage_id, array_yaml):
    array_template_file = os.path.join(self.YAML_DIR, self.ARRAY_YAML_TEMPLATE)
    print(array_template_file)
    f = open(array_template_file, "r+")
    yml = f.read()
    f.close()

    yml = yml.replace(self.HOSTER_ID_TAG, hoster_id)
    yml = yml.replace(self.PORTAL_ID_TAG, portal_id)
    yml = yml.replace(self.RACK_ID_TAG, rack_id)
    yml = yml.replace(self.POD_ID_TAG, pod_id)
    yml = yml.replace(self.ACS_TAG, acs)
    yml = yml.replace(self.ARRAY_ID_TAG, array_id)
    yml = yml.replace(self.STORAGE_ID_TAG, storage_id)
    print(yml)
    
    array_file = os.path.join(self.YAML_DIR, array_yaml)
    with open(array_file, "w+") as f:
      f.write(yml)
    

  def create_array(self, array_yaml):
    array_file = os.path.join(self.YAML_DIR, array_yaml)
    cmd = "./qctl arrays create -f %s"%(array_file)
    stream = os.popen(cmd)
    output = stream.read()
    print(output)
    if "error" in output:
      return False, output

    return True, output


  def delete_array(self, array_id):
    cmd = "./qctl arrays delete %s"%(array_id)
    stream = os.popen(cmd)
    output = stream.read()
    print(output)
    if "error" in output:
      return False, output

    return True, output


