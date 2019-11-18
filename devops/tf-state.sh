#!/bin/sh

MODULES_DIR=modules
MODULES_URL=https://github.com/jtviegas/terraform-modules/trunk/modules
this_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

usage()
{
  cat <<EOM
  usage:
  $(basename $0) [dev|pro] [deploy|undeploy]
EOM
  exit 1
}

[ -z $2 ] && { usage; }
[ ! "$2" == "deploy" ] && [ ! "$2" == "undeploy" ] && { usage; }
[ ! "$1" == "dev" ] && [ ! "$1" == "pro" ] && { usage; }

env="$1"
run_folder="${this_folder}/tf-state/$1"
vars_folder="${this_folder}/variables"
variables_src_file="${vars_folder}/${env}.tf"
variables_run_file="${run_folder}/variables.tf"

echo "starting [ $0 $1 $2 ]..."
_pwd=$(pwd)

cd "${run_folder}"
cp "$variables_src_file" "$variables_run_file"
svn export -q "$MODULES_URL" "$MODULES_DIR"

if [ "$2" == "deploy" ]; then
    terraform init
    terraform plan
    terraform apply -auto-approve -lock=true -lock-timeout=5m
else
    terraform destroy -auto-approve -lock=true -lock-timeout=5m
fi

rm -rf "$MODULES_DIR"
rm -rf "$variables_run_file"
cd "$_pwd"
echo "...[ $0 $1 $2 ] done."