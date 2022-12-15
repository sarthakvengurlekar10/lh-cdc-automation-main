__version__ = '1.0.0'

import os
import re
import yaml

class VolumeAttachment(object):
  ROBOT_LIBRARY_VERSION = __version__
  ROBOT_LIBRARY_SCOPE = 'GLOBAL'
  YAML_DIR = "yamls"
  HOSTER_ID_TAG = "${HOSTER_ID}"
  PORTAL_ID_TAG = "${PORTAL_ID}"
  VOL_ID_TAG = "${VOL_ID}"
  VOL_ATTACHMENT_ID_TAG = "${VOL_ATTACHMENT_ID}"
  VOL_ATTACHMENT_NAME_TAG = "${VOL_ATTACHMENT_NAME}"
  VOL_ATTACHMENT_YAML_TEMPLATE = "volume_attachment.yml.tmpl"
 

  def list_volume_attachments(self):
    stream = os.popen("./qctl volumeattachments list")
    output = stream.readlines()
    if len(output) < 3:
       return []

    volume_attachment_ids = []
    for line in output[2:]:
        match = re.search(r"\w+-\w+-\w+-\w+-\w+", line)
        if match is None:
          continue
        volume_ids.append(match.group(0))

    return volume_attachment_ids


  def create_volume_attachment_yaml(self, portal_id, hoster_id, vol_attachment_id, vol_attachment_name, vol_id, vol_attachment_yaml):
    template_file = os.path.join(self.YAML_DIR, self.VOL_ATTACHMENT_YAML_TEMPLATE)
    print(template_file)
    f = open(template_file, "r+")
    yml = f.read()
    f.close()

    yml = yml.replace(self.PORTAL_ID_TAG, portal_id)
    yml = yml.replace(self.HOSTER_ID_TAG, hoster_id)
    yml = yml.replace(self.VOL_ATTACHMENT_ID_TAG, vol_attachment_id)
    yml = yml.replace(self.VOL_ATTACHMENT_NAME_TAG, vol_attachment_name)
    yml = yml.replace(self.VOL_ID_TAG, vol_id)
    print(yml)
    
    file = os.path.join(self.YAML_DIR, vol_attachment_yaml)
    with open(file, "w+") as f:
      f.write(yml)


  def create_volume_attachment(self, yaml_file):
    file = os.path.join(self.YAML_DIR, yaml_file)
    cmd = "./qctl volumeattachments create -f %s"%(file)
    stream = os.popen(cmd)
    output = stream.read()
    print(output)
    if "error" in output:
      return False, output

    return True, output


  def delete_volume_attachment(self, id):
    cmd = "./qctl volumeattachments delete %s"%(id)
    stream = os.popen(cmd)
    output = stream.read()
    print(output)
    if "error" in output:
      return False, output

    return True, output


  def get_user_ticket(self, id):
    cmd = "./qctl volumeattachments get %s"%(id)
    stream = os.popen(cmd)
    output = stream.read()
    yml = yaml.safe_load(output)
    print(yml)
    return yml["fs_config"]["ticket"]

