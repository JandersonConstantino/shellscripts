import sys
import os
import json
import shutil

package_json_path=sys.argv[1]
pwd=sys.argv[2]
script_path=os.environ.get("AUTO_GENERATE_NPMRC_PATH")
configs_path=script_path + "/configs.json"
repository_url=None
npmrc_path=None
npmrc_dest_path=pwd + "/.npmrc"

def get_npmrc_path(filename: str):
  return script_path + "/npmrc_files/" + filename

try:
  data=json.load(open(package_json_path))
  repository_url = data['repository']['url']
except KeyError:
  exit(0)

try:
  if str(data['repository']['directory']).startswith("packages"):
    exit(0)
except KeyError:
  pass

data=json.load(open(configs_path))

for item in data:
  if str(repository_url).startswith(item['starts_with']):
    npmrc_path=get_npmrc_path(item['npmrc_filename'])

if npmrc_path == None:
  exit(0)

shutil.copyfile(npmrc_path, npmrc_dest_path)

print(".npmrc auto gerenated")
