#!/bin/sh

TERRAFORM_ZIP=https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip
MODULES_DIR=modules
MODULES_URL=https://github.com/jtviegas/terraform-modules/trunk/modules

this_folder=$(dirname $(readlink -f $0))
if [ -z  $this_folder ]; then
  this_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
fi
base_folder=$(dirname "$this_folder")
echo "this_folder: $this_folder | base_folder: $base_folder"

usage()
{
  cat <<EOM
  usage:
  $(basename $0) [dev|pro] [yes|no]
EOM
  exit 1
}

[ -z $2 ] && { usage; }
[ "$2" != "yes" ] && [ "$2" != "no" ] && { usage; }
[ "$1" != "dev" ] && [ "$1" != "pro" ] && { usage; }

env="$1"
run_folder="${this_folder}/deployments/${env}"
vars_folder="${this_folder}/variables"
variables_src_file="${vars_folder}/${env}.tf"
variables_run_file="${run_folder}/variables.tf"

build_script="$this_folder/build.sh"
terraform_command=terraform


echo "starting [ $0 $1 $2 ]..."
_pwd=$(pwd)
echo "...leaving $_pwd to $run_folder ..."
cd "$run_folder"
cp "$variables_src_file" "$variables_run_file"

which terraform
if [ ! "$?" -eq "0" ] ; then
  echo "...have to install terraform..."
  terraform_command=./terraform
  wget $TERRAFORM_ZIP -O terraform.zip --quiet
  unzip terraform.zip
fi

svn export -q "$MODULES_URL" "$MODULES_DIR"

if [ "$2" == "yes" ]; then
    $build_script
    ls -altr
    $terraform_command init
    $terraform_command plan
    $terraform_command apply -auto-approve -lock=true -lock-timeout=5m
else
    $terraform_command destroy -auto-approve -lock=true -lock-timeout=5m
fi
__r=$?
rm -rf "$MODULES_DIR"
rm -rf "$variables_run_file"
rm -rf terraform*
echo "...returning to $_pwd..."
cd "$_pwd"
echo "...[ $0 $1 $2 ] done."
exit $__r