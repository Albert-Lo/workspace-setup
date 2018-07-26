function main {
  local _cwd=$(pwd);
  local _USER=$1;
  local _PASS=$2;

  local _NEXT_LINK="https://api.bitbucket.org/2.0/repositories/ooapi?pagelen=100";

  sudo mkdir -p /var/oo;
  sudo chown -R ${USER}:$(groups | grep -Eo "^[^ ]+") /var/oo;
  cd /var/oo;

  while [ ! -z "$_NEXT_LINK" ]; do
    local _text=$(curl -u $_USER:$_PASS $_NEXT_LINK | sed -E 's/}|]|,/\
      /g');
    local _repos=$(echo "${_text}" | grep -o "git@.*\.git");
    _NEXT_LINK=$(echo "${_text}" | grep -oE "\"next\": \"https:\/\/api.bitbucket.org\/2.0\/repositories\/ooapi.*page=[0-9]+" | grep -oE "https:\/\/api.bitbucket.org\/2.0\/repositories\/ooapi.*page=[0-9]+");
    for _repo in $_repos; do
      git clone $_repo
    done
  done

  cd $_cwd;

  return 0;
}

main $1 $2;
