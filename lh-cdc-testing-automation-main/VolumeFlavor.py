__version__ = '1.0.0'

import os
import re
import yaml

class VolumeFlavor(object):
  ROBOT_LIBRARY_VERSION = __version__
  ROBOT_LIBRARY_SCOPE = 'GLOBAL'
  YAML_DIR = "yamls"
  HOSTER_ID_TAG = "${HOSTER_ID}"
  PORTAL_ID_TAG = "${PORTAL_ID}"
  VOL_FLAVOR_ID_TAG = "${VOL_FLAVOR_ID}"
  VOL_FLAVOR_NAME_TAG = "${VOL_FLAVOR_NAME}"
  LATENCY_VALUE_TAG = "${LATENCY_VALUE}"
  FLAVOR_YAML_TEMPLATE = "volume_flavor.yml.tmpl"


  def list_volume_flavors(self):
    stream = os.popen("./qctl volumeflavors list")
    output = stream.readlines()
    if len(output) < 3:
        return []

    flavor_ids = []
    for line in output[2:]:
        match = re.search(r"\w+-\w+-\w+-\w+-\w+", line)
        if match is None:
            continue
        flavor_ids.append(match.group(0))

    return flavor_ids


  def create_volume_flavor_yaml_attributes(self, portal_id, hoster_id, flavor_id, name, latency_value, replication_factor, replication_type, label_value, ec_enable, container_allocation, ec_label, flavor_yaml):
    template_file = os.path.join(self.YAML_DIR, self.FLAVOR_YAML_TEMPLATE)
    print(template_file)
    try:
      f = open(template_file, "r+")
    except yaml.YAMLError as exc:
      print("Error in opening configuration file:", exc)
    
    yml = yaml.safe_load(f)
    if yml is None:
      print("Error loading the yaml file")
      return False
    f.close()
    print("Evaluating values for yaml configuration")
    print(yml)
    print("portal_id = ", portal_id)
    print("hoster_id = ", hoster_id)
    print("name = ", name)
    print("flavor id = ", flavor_id)
    print("latency value = ", latency_value)
    try:
      yml["portal_id"] = portal_id
      yml["hoster_id"] = hoster_id
      yml["id"] = flavor_id
      yml["name"] = name
      yml["classifiers"][0]["rules"][0]["value"] = latency_value
    except Exception as exc:
      print("Invalid yaml attributes")
    print("Evaluating yaml attributes")
    print(yml)
    print("replication Factor = ", replication_factor)
    try:
      yml["storage_attributes"] = []
      if replication_factor != "":
          yml["storage_attributes"].append({"attribute": "replicationFactor","value":replication_factor})
      if replication_type != "":
          yml["storage_attributes"].append({"attribute": "replicationType","value":replication_type})
      if label_value != "":
          yml["storage_attributes"].append({"attribute": "label","value":label_value})
      if ec_enable != "": 
          yml["storage_attributes"].append({"attribute": "ecEnable","value":ec_enable})
      if container_allocation != "": 
          yml["storage_attributes"].append({"attribute": "containerAllocationFactor","value":container_allocation})
      if ec_label != "": 
          yml["storage_attributes"].append({"attribute": "ecLabel","value":ec_label})
    except Exception as exc:
      print("Invalid argument type", exc)

    flavor_yaml = os.path.join(self.YAML_DIR, flavor_yaml)
    print("saving to yaml file ", flavor_yaml)
    stream = open(flavor_yaml, 'w')
    yaml.dump(yml, stream) 
    stream.close()
    print(yml)   

  def create_volume_flavor_yaml(self, portal_id, hoster_id, flavor_id, name, latency_value, replication_factor, replication_type, label_value, flavor_yaml):
    template_file = os.path.join(self.YAML_DIR, self.FLAVOR_YAML_TEMPLATE)
    print(template_file)
    f = open(template_file, "r+")
    yml = f.read()
    f.close()

    yml = yml.replace(self.HOSTER_ID_TAG, hoster_id)
    yml = yml.replace(self.PORTAL_ID_TAG, portal_id)
    yml = yml.replace(self.VOL_FLAVOR_ID_TAG, flavor_id)
    yml = yml.replace(self.VOL_FLAVOR_NAME_TAG, name)
    yml = yml.replace(self.LATENCY_VALUE_TAG, latency_value)
    print(yml)
    
    file = os.path.join(self.YAML_DIR, flavor_yaml)
    with open(file, "w+") as f:
        f.write(yml)
    

  def create_volume_flavor(self, flavor_yaml):
    file = os.path.join(self.YAML_DIR, flavor_yaml)
    cmd = "./qctl volumeflavors create -f %s"%(file)
    stream = os.popen(cmd)
    output = stream.read()
    print(output)
    if "error" in output:
        return False, output

    return True, output


  def delete_volume_flavor(self, flavor_id):
    cmd = "./qctl volumeflavors delete %s"%(flavor_id)
    stream = os.popen(cmd)
    output = stream.read()
    print(output)
    if "error" in output:
        return False, output

    return True, output


